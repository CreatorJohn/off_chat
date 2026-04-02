import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/features/discovery/domain/discovered_device_model.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';

part 'discovery_controller.g.dart';

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

    // Start scanning
    bleServiceInstance.startScanning();

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
      if (manufacturerData.containsKey(0xFFFF)) { // Using the test ID from ble_service
        final payload = manufacturerData[0xFFFF]!;
        
        // Ensure payload is exactly 13 bytes
        if (payload.length == 13) {
          final deviceId = result.device.remoteId.str;
          
          // Basic parsing (simplified for the prototype phase)
          // A full implementation would use ByteData to extract the floats and uint32
          
          final existingDevice = await isar.discoveredDeviceModels.where().deviceIdEqualTo(deviceId).findFirst();
          
          if (existingDevice != null) {
            // Update last seen
            await isar.writeTxn(() async {
              existingDevice.lastDiscovered = DateTime.now();
              await isar.discoveredDeviceModels.put(existingDevice);
            });
            updated = true;
          } else {
            // Create new device
            final newDevice = DiscoveredDeviceModel()
              ..deviceId = deviceId
              ..username = 'Unknown Node' // Will be fetched via direct connection later
              ..lastDiscovered = DateTime.now();
            
            await isar.writeTxn(() async {
              await isar.discoveredDeviceModels.put(newDevice);
            });
            updated = true;
          }
        }
      }
    }

    if (updated) {
      // Refresh the UI state
      state = AsyncData(await isar.discoveredDeviceModels.where().findAll());
    }
  }

  Future<void> manualRefresh() async {
    final isar = await ref.read(isarDatabaseProvider.future);
    state = const AsyncLoading();
    state = AsyncData(await isar.discoveredDeviceModels.where().findAll());
  }
}
