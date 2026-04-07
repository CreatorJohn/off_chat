import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:isar/isar.dart';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/features/discovery/domain/discovered_device_model.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';

part 'discovery_controller.g.dart';

final _log = Logger('DiscoveryController');

@riverpod
class DiscoveryController extends _$DiscoveryController {
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  @override
  FutureOr<List<DiscoveredDeviceModel>> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);
    
    // Start listening to scan results
    final bleServiceInstance = ref.read(bleServiceProvider);
    _scanSubscription = bleServiceInstance.scanResults.listen((results) {
      _processScanResults(results, isar);
    });

    // Start scanning (don't await so we can return initial data immediately)
    bleServiceInstance.startScanning().catchError((e) {
      // Log or handle scan error
      _log.severe('Scan startup error: $e');
    });

    ref.onDispose(() {
      _scanSubscription?.cancel();
      bleServiceInstance.stopScanning();
    });

    // Return the initial list from the database
    return await isar.discoveredDeviceModels.where().findAll();
  }

  Future<void> _processScanResults(List<ScanResult> results, Isar isar) async {
    bool updated = false;

    for (final result in results) {
      // Look for our specific Manufacturer Data in the Scan Response
      final manufacturerData = result.advertisementData.manufacturerData;
      
      // Extract data if present (foreground device)
      final bool hasOffChatData = manufacturerData.containsKey(0xFFFF);
      
      final deviceId = result.device.remoteId.str;
      final existingDevice = await isar.discoveredDeviceModels.where().deviceIdEqualTo(deviceId).findFirst();

      if (hasOffChatData) {
        final payload = manufacturerData[0xFFFF]!;
        if (payload.length == 13) {
          final byteData = ByteData.sublistView(Uint8List.fromList(payload));
          final flags = byteData.getUint8(0);
          final lat = byteData.getFloat32(5, Endian.little);
          final lng = byteData.getFloat32(9, Endian.little);
          final isLocationVisible = (flags & (1 << 1)) != 0;

          if (existingDevice != null) {
            await isar.writeTxn(() async {
              existingDevice.lastDiscovered = DateTime.now();
              if (isLocationVisible) {
                existingDevice.latitude = lat;
                existingDevice.longitude = lng;
              }
              await isar.discoveredDeviceModels.put(existingDevice);
            });
            updated = true;
          } else {
            final newDevice = DiscoveredDeviceModel()
              ..deviceId = deviceId
              ..username = 'Connecting...'
              ..lastDiscovered = DateTime.now();
            
            if (isLocationVisible) {
              newDevice.latitude = lat;
              newDevice.longitude = lng;
            }
            
            await isar.writeTxn(() async {
              await isar.discoveredDeviceModels.put(newDevice);
            });
            updated = true;
            
            // Initiate Identity Sync
            _syncPeerIdentity(result.device, isar);
          }
        }
      } else if (existingDevice == null) {
        // This might be an OffChat device in the background (no scan response data)
        // Check if it has our Service UUID
        if (result.advertisementData.serviceUuids.contains(Guid(offChatServiceUuid))) {
           final newDevice = DiscoveredDeviceModel()
              ..deviceId = deviceId
              ..username = 'Connecting...'
              ..lastDiscovered = DateTime.now();
            
            await isar.writeTxn(() async {
              await isar.discoveredDeviceModels.put(newDevice);
            });
            updated = true;
            
            _syncPeerIdentity(result.device, isar);
        }
      }
    }

    if (updated) {
      // Refresh the UI state
      state = AsyncData(await isar.discoveredDeviceModels.where().findAll());
    }
  }

  Future<void> _syncPeerIdentity(BluetoothDevice device, Isar isar) async {
    try {
      await device.connect(timeout: const Duration(seconds: 5), license: License.free);
      final services = await device.discoverServices();
      final offChatService = services.firstWhere((s) => s.uuid == Guid(offChatServiceUuid));
      final char = offChatService.characteristics.firstWhere((c) => c.uuid == Guid(identityCharUuid));
      
      final value = await char.read();
      final identityJson = utf8.decode(value);
      final identityData = jsonDecode(identityJson) as Map<String, dynamic>;
      
      final existingDevice = await isar.discoveredDeviceModels.where().deviceIdEqualTo(device.remoteId.str).findFirst();
      if (existingDevice != null) {
        await isar.writeTxn(() async {
          existingDevice.username = identityData['username'] as String?;
          await isar.discoveredDeviceModels.put(existingDevice);
        });
        state = AsyncData(await isar.discoveredDeviceModels.where().findAll());
      }
    } catch (e) {
      _log.severe('Identity sync failed for ${device.remoteId.str}: $e');
    } finally {
      await device.disconnect();
    }
  }

  Future<void> manualRefresh() async {
    final isar = await ref.read(isarDatabaseProvider.future);
    state = const AsyncLoading();
    state = AsyncData(await isar.discoveredDeviceModels.where().findAll());
  }
}
