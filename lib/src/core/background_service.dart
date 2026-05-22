import 'dart:async';
import 'dart:ui';

import 'package:off_chat/src/features/discovery/data/ble_advertiser.dart';
import 'package:off_chat/src/features/discovery/data/ble_discoverer.dart';
import 'package:off_chat/src/core/database/isar_service.dart';
import 'package:off_chat/src/features/chat/data/message_handler.dart';
import 'package:off_chat/src/features/profile/data/profile_manager.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logging/logging.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';
import 'package:off_chat/src/core/notifications/notification_service.dart';

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();
  if (await service.isRunning()) return;

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'scanning_status',
    'BLE Status',
    importance: Importance.low,
  );
  final notificationPlugin = FlutterLocalNotificationsPlugin();
  await notificationPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: "scanning_status",
      initialNotificationTitle: "BLE Mesh Active",
      initialNotificationContent: "Monitoring mesh network",
      foregroundServiceTypes: [
        AndroidForegroundType.location,
        AndroidForegroundType.connectedDevice,
      ],
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: (_) async => true,
    ),
  );
}

final Logger log = Logger('BackgroundService');

@pragma("vm:entry-point")
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  final advertiser = BLEAdvertiser();
  await NotificationService().init();

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen(
    (r) => service.invoke('log', {
      'message':
          '[BG] [${r.time.hour}:${r.time.minute}:${r.time.second}] [${r.level.name}] ${r.loggerName}: ${r.message}',
      'level': r.level.name,
      'loggerName': r.loggerName,
    }),
  );

  log.info('Service isolate started');
  if (!BLEAdvertiser.initialized) {
    await advertiser.initialize(ignorePermissions: true).then((_) {
      log.info("BLEAdvertiser initialized!");
    }).catchError((_) {
      log.severe("Failed to initialized BLEAdvertiser!");
    });
  }

  runZonedGuarded(
    () async => await _startServiceLogic(service, advertiser),
    (error, stack) => log.severe('Top-level error: $error', error, stack),
  );
}

Future<void> _startServiceLogic(
  ServiceInstance service,
  BLEAdvertiser advertiser,
) async {
  UserModel? user = await UserModel.load();
  
  double currentLat = 0.0, currentLon = 0.0;
  bool isOnline = false, isAdUpdating = false, needsTrailingUpdate = false;
  DateTime lastAdStartTime = DateTime.fromMillisecondsSinceEpoch(0);

  Future<void> updateAd() async {
    // Reload user to get latest name/onboarding status
    user = await UserModel.load();
    if (user == null || !user!.isOnboarded || !BLEAdvertiser.initialized) return;

    final now = DateTime.now();
    final timeSinceLastStart = now.difference(lastAdStartTime);
    
    if (isAdUpdating || 
        BLEAdvertiser.hasInboundConnections || 
        timeSinceLastStart < const Duration(seconds: 10)) {
      log.info('Ad update throttled. Waiting... (Elapsed: ${timeSinceLastStart.inSeconds}s)');
      needsTrailingUpdate = true;
      return;
    }

    isAdUpdating = true;
    needsTrailingUpdate = false;
    try {
      if (advertiser.isAdvertising) {
        await advertiser.stopAdvertising();
        await Future.delayed(const Duration(milliseconds: 500));
      }
      await advertiser.startAdvertising(
        localName: user!.username,
        latitude: currentLat,
        longitude: currentLon,
        isOnline: isOnline,
      );
      lastAdStartTime = DateTime.now();
      service.invoke("advertisingChange", {"active": true});
    } catch (e) {
      log.severe('Ad update fail: $e');
    }

    Timer(const Duration(seconds: 10), () {
      isAdUpdating = false;
      if (needsTrailingUpdate && user != null && user!.isOnboarded) {
        log.info('Executing queued trailing ad update');
        updateAd();
      }
    });
  }

  BLEAdvertiser.connectionStream.listen((event) {
    if (!event.values.first && needsTrailingUpdate && user != null && user!.isOnboarded) updateAd();
  });

  Geolocator.getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    ),
  ).listen((p) {
    currentLat = p.latitude;
    currentLon = p.longitude;
    if (user != null && user!.isOnboarded) updateAd();
  });

  final isar = IsarService();
  await isar.initialize();
  await isar.pruneDatabase();
  MessageHandler.initialize(service: service);

  final myStableId = await ProfileManager.getStableDeviceId();

  // Start Discovery Engine
  BLEDiscoverer().start(service, isar, myStableId);

  // Initial Ad Start
  if (user != null && user!.isOnboarded) {
    log.info('Auto-starting advertising for onboarded user: ${user!.username}');
    updateAd();
  }

  Timer.periodic(const Duration(minutes: 2), (_) => MessageHandler.checkExpiredMessages());

  service.on('stopService').listen((_) async {
    BLEDiscoverer().stop();
    await advertiser.stopAdvertising();
    service.stopSelf();
  });
  
  service.on('startAdvertising').listen((e) async {
    // Force immediate update if requested (e.g. from onboarding)
    updateAd();
  });
  
  service.on('setOnlineStatus').listen((e) {
    final status = e?['isOnline'];
    if (status is bool) {
      isOnline = status;
      if (user != null && user!.isOnboarded) updateAd();
    }
  });
  
  service.on("stopAdvertising").listen((_) async {
    // We don't have a persistent flag anymore, but we can stop the current broadcast.
    // Note: It will restart on next location change or app relaunch if onboarded.
    await advertiser.stopAdvertising();
    service.invoke("advertisingChange", {"active": false});
  });
  
  service.on("updateLocalProfile").listen((_) => updateAd());
  
  service.on('sendMessage').listen((e) async {
    final targetId = e?['targetId'];
    final content = e?['content'];
    if (targetId is int && content is String) {
      await MessageHandler.sendMessage(targetStableId: targetId, content: content);
    }
  });
}
