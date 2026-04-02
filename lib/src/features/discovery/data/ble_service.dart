import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart' as per;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

const String OFF_CHAT_SERVICE_UUID = "4a1a5fc0-67a4-4a4c-83b3-8a301bd9b210";
const String IDENTITY_CHAR_UUID = "4a1a5fc1-67a4-4a4c-83b3-8a301bd9b210";
const String MESSAGE_CHAR_UUID = "4a1a5fc2-67a4-4a4c-83b3-8a301bd9b210";
const String IMAGE_CHAR_UUID = "4a1a5fc3-67a4-4a4c-83b3-8a301bd9b210";

class OffChatBleService {
  final _blePeripheral = per.FlutterBlePeripheral();
  
  final _messageController = StreamController<({String senderId, String text})>.broadcast();
  final _imageController = StreamController<({String senderId, Uint8List imageBytes})>.broadcast();

  Stream<({String senderId, String text})> get incomingMessages => _messageController.stream;
  Stream<({String senderId, Uint8List imageBytes})> get incomingImages => _imageController.stream;

  void handleIncomingMessage(String senderId, String text) {
    _messageController.add((senderId: senderId, text: text));
  }

  void handleIncomingImage(String senderId, Uint8List bytes) {
    _imageController.add((senderId: senderId, imageBytes: bytes));
  }

  Future<void> startAdvertising({
    required int platformFlag,
    required bool isLocationVisible,
    required int profileHash,
    required double latitude,
    required double longitude,
  }) async {
    final ByteData byteData = ByteData(13);
    int flags = 0;
    if (platformFlag == 1) flags |= (1 << 0);
    if (isLocationVisible) flags |= (1 << 1);
    byteData.setUint8(0, flags);
    byteData.setUint32(1, profileHash, Endian.little);
    byteData.setFloat32(5, latitude, Endian.little);
    byteData.setFloat32(9, longitude, Endian.little);

    final per.AdvertiseData advertiseData = per.AdvertiseData(
      serviceUuid: OFF_CHAT_SERVICE_UUID,
      includeDeviceName: false,
    );

    final per.AdvertiseData scanResponse = per.AdvertiseData(
      manufacturerId: 0xFFFF,
      manufacturerData: byteData.buffer.asUint8List(),
    );

    try {
      await _blePeripheral.start(
        advertiseData: advertiseData,
        advertiseResponseData: scanResponse,
      );
    } catch (e) {
      // Log error
    }
  }

  Future<void> stopAdvertising() async {
    await _blePeripheral.stop();
  }

  Stream<List<fbp.ScanResult>> get scanResults => fbp.FlutterBluePlus.scanResults;

  Future<void> startScanning() async {
    await fbp.FlutterBluePlus.startScan(
      withServices: [fbp.Guid(OFF_CHAT_SERVICE_UUID)],
      continuousUpdates: true,
    );
  }

  Future<void> stopScanning() async {
    await fbp.FlutterBluePlus.stopScan();
  }

  Future<void> sendMessage(String remoteId, String text) async {
    final device = fbp.BluetoothDevice.fromId(remoteId);
    try {
      await device.connect(license: fbp.License.free);
      final services = await device.discoverServices();
      final offChatService = services.firstWhere((s) => s.uuid == fbp.Guid(OFF_CHAT_SERVICE_UUID));
      final char = offChatService.characteristics.firstWhere((c) => c.uuid == fbp.Guid(MESSAGE_CHAR_UUID));
      await char.write(Uint8List.fromList(text.codeUnits));
    } finally {
      await device.disconnect();
    }
  }

  Future<void> sendImage(String remoteId, Uint8List imageBytes) async {
    final device = fbp.BluetoothDevice.fromId(remoteId);
    try {
      await device.connect(license: fbp.License.free);
      final services = await device.discoverServices();
      final offChatService = services.firstWhere((s) => s.uuid == fbp.Guid(OFF_CHAT_SERVICE_UUID));
      final char = offChatService.characteristics.firstWhere((c) => c.uuid == fbp.Guid(IMAGE_CHAR_UUID));
      
      int mtu = await device.mtu.first;
      int offset = 0;
      while (offset < imageBytes.length) {
        int end = offset + mtu - 3;
        if (end > imageBytes.length) end = imageBytes.length;
        await char.write(imageBytes.sublist(offset, end), withoutResponse: true);
        offset = end;
      }
    } finally {
      await device.disconnect();
    }
  }
}

@Riverpod(keepAlive: true)
OffChatBleService bleService(BleServiceRef ref) {
  return OffChatBleService();
}
