import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:crclib/catalog.dart';
import 'package:ble_peripheral/ble_peripheral.dart' as per;
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';
import 'package:off_chat/src/features/location/data/location_service.dart';

part 'advertising_controller.g.dart';

@Riverpod(keepAlive: true)
class AdvertisingController extends _$AdvertisingController {
  @override
  FutureOr<void> build() async {
    final user = await ref.watch(profileControllerProvider.future);
    if (user == null || !user.isOnboarded) return;

    // Request permissions before proceeding
    if (Platform.isAndroid) {
      final status = await [
        Permission.bluetoothScan,
        Permission.bluetoothAdvertise,
        Permission.bluetoothConnect,
        Permission.location,
      ].request();

      if (status.values.any((s) => s.isDenied)) {
        return; // Cannot advertise without permissions
      }
    }

    final locationAsync = ref.watch(locationServiceProvider);
    final bleServiceInstance = ref.read(bleServiceProvider);

    final latitude = locationAsync.value?.latitude ?? 0.0;
    final longitude = locationAsync.value?.longitude ?? 0.0;

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
    
    final per.BleService service = per.BleService(
      uuid: offChatServiceUuid,
      primary: true,
      characteristics: [
        per.BleCharacteristic(
          uuid: identityCharUuid,
          properties: [
            per.CharacteristicProperties.read.index,
          ],
          permissions: [
            per.AttributePermissions.readable.index,
          ],
          value: Uint8List.fromList(utf8.encode(identityJson)),
        ),
        per.BleCharacteristic(
          uuid: messageCharUuid,
          properties: [
            per.CharacteristicProperties.write.index,
            per.CharacteristicProperties.writeWithoutResponse.index,
          ],
          permissions: [
            per.AttributePermissions.writeable.index,
          ],
        ),
        per.BleCharacteristic(
          uuid: imageCharUuid,
          properties: [
            per.CharacteristicProperties.write.index,
            per.CharacteristicProperties.writeWithoutResponse.index,
          ],
          permissions: [
            per.AttributePermissions.writeable.index,
          ],
        ),
      ],
    );

    await bleServiceInstance.addService(service);

    // Start Advertising
    await bleServiceInstance.startAdvertising(
      platformFlag: Platform.isAndroid ? 0 : 1,
      isLocationVisible: user.isLocationVisible,
      profileHash: profileHash,
      latitude: latitude,
      longitude: longitude,
    );

    ref.onDispose(() {
      bleServiceInstance.stopAdvertising();
    });
  }
}
