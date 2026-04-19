import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crclib/catalog.dart';
import 'package:ble_peripheral/ble_peripheral.dart' as per;
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';
import 'package:off_chat/src/features/location/data/location_service.dart';

part 'advertising_controller.g.dart';

final _log = Logger('AdvertisingController');

@Riverpod(keepAlive: true)
class AdvertisingController extends _$AdvertisingController {
  double? _lastLat;
  double? _lastLng;
  DateTime? _lastUpdateTime;
  String? _lastIdentityJson;
  bool _isBuilding = false;
  bool _isDisposalRegistered = false;

  @override
  FutureOr<void> build() async {
    // Busy Guard: Prevent concurrent build executions
    if (_isBuilding) {
      _log.info('Build already in progress, skipping concurrent trigger.');
      return;
    }
    _isBuilding = true;
    _log.info("Trying to update the advertising data...");

    try {
      final user = await ref.watch(profileControllerProvider.future);
      if (user == null || !user.isOnboarded) return;

      final bleServiceInstance = ref.read(bleServiceProvider);

      if (!_isDisposalRegistered) {
        ref.onDispose(() {
          bleServiceInstance.stopAdvertising();
        });
        _isDisposalRegistered = true;
      }

      // Request permissions before proceeding
      if (Platform.isAndroid) {
        final status = await [
          Permission.bluetoothScan,
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
          Permission.location,
        ].request();

        if (status.values.any((s) => s.isDenied)) {
          _log.severe('BLE permissions denied.');
          return;
        }
      }

      // Initialize BLE only after permissions
      await bleServiceInstance.initialize();

      // IMPORTANT: Only watch lat, lng, and speed. Ignore heading (compass) to prevent constant rebuilds.
      final locationData = ref.watch(
        locationServiceProvider.select(
          (value) => value.hasValue
              ? (
                  lat: value.value!.latitude,
                  lng: value.value!.longitude,
                  speed: value.value!.speed,
                )
              : null,
        ),
      );

      if (locationData == null) {
        _log.warning("Location data will be missing in the advertising data!");
      }

      final latitude = locationData?.lat ?? 0;
      final longitude = locationData?.lng ?? 0;
      final speed = locationData?.speed ?? 0;

      final now = DateTime.now();
      bool shouldUpdate = false;

      if (_lastLat == null || _lastUpdateTime == null) {
        shouldUpdate = true;
      } else {
        final timeSinceUpdate = now.difference(_lastUpdateTime!).inSeconds;

        // High-Speed (Flight Mode) Check: > 20 m/s (72 km/h)
        if (speed >= 20.0) {
          if (timeSinceUpdate >= 120) {
            _log.info(
              'High-speed detected ($speed m/s). Throttling updates to 2 mins.',
            );
            shouldUpdate = true;
          }
        } else {
          // Normal Mode: Check if moved > 100 meters
          final latDist = (latitude - _lastLat!).abs();
          final lngDist = (longitude - _lastLng!).abs();
          // Also check for a 5-minute heartbeat update
          if (latDist > 0.001 || lngDist > 0.001 || timeSinceUpdate > 300) {
            shouldUpdate = true;
          }
        }
      }

      if (!shouldUpdate) {
        _log.severe("Failed to update the advertising data!");
        return;
      }

      _log.info("Advertising data will be updated!");

      // Commit state updates BEFORE starting async BLE work to block rapid re-triggers
      _lastLat = latitude;
      _lastLng = longitude;
      _lastUpdateTime = now;

      // Calculate Profile Hash
      final profileData = '${user.username}${user.profilePicturePath ?? ''}';
      final profileHashValue = Crc32IsoHdlc().convert(utf8.encode(profileData));
      final profileHash = int.parse(profileHashValue.toString());

      // Prepare Identity GATT Service
      final identityData = {
        'username': user.username,
        'hasImage': user.profilePicturePath != null,
      };
      final identityJson = jsonEncode(identityData);

      if (_lastIdentityJson != identityJson) {
        final per.BleService service = per.BleService(
          uuid: offChatServiceUuid,
          primary: true,
          characteristics: [
            per.BleCharacteristic(
              uuid: identityCharUuid,
              properties: [per.CharacteristicProperties.read.index],
              permissions: [per.AttributePermissions.readable.index],
              value: Uint8List.fromList(utf8.encode(identityJson)),
            ),
            per.BleCharacteristic(
              uuid: messageCharUuid,
              properties: [
                per.CharacteristicProperties.write.index,
                per.CharacteristicProperties.writeWithoutResponse.index,
              ],
              permissions: [per.AttributePermissions.writeable.index],
            ),
            per.BleCharacteristic(
              uuid: imageCharUuid,
              properties: [
                per.CharacteristicProperties.write.index,
                per.CharacteristicProperties.writeWithoutResponse.index,
              ],
              permissions: [per.AttributePermissions.writeable.index],
            ),
          ],
        );

        await bleServiceInstance.addService(service);
        _lastIdentityJson = identityJson;
      }

      _log.info("Device started advertising!");

      // Start Advertising
      await bleServiceInstance.startAdvertising(
        platformFlag: Platform.isAndroid ? 0 : 1,
        isLocationVisible: user.isLocationVisible,
        profileHash: profileHash,
        latitude: latitude,
        longitude: longitude,
      );
    } finally {
      _isBuilding = false;
    }
  }
}
