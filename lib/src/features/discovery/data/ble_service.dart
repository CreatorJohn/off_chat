import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:ble_peripheral/ble_peripheral.dart' as per;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

const String offChatServiceUuid = "4a1a5fc0-67a4-4a4c-83b3-8a301bd9b210";
const String identityCharUuid = "4a1a5fc1-67a4-4a4c-83b3-8a301bd9b210";
const String messageCharUuid = "4a1a5fc2-67a4-4a4c-83b3-8a301bd9b210";
const String imageCharUuid = "4a1a5fc3-67a4-4a4c-83b3-8a301bd9b210";

class OffChatBleService {
  final _messageController = StreamController<({String senderId, String text})>.broadcast();
  final _imageController = StreamController<({String senderId, Uint8List imageBytes})>.broadcast();
  final _advertisingController = StreamController<bool>.broadcast();

  Stream<({String senderId, String text})> get incomingMessages => _messageController.stream;
  Stream<({String senderId, Uint8List imageBytes})> get incomingImages => _imageController.stream;

  Stream<bool> get isScanning => fbp.FlutterBluePlus.isScanning;
  Stream<bool> get isAdvertising => _advertisingController.stream;

  OffChatBleService() {
    _initPeripheral();
  }

  Future<void> _initPeripheral() async {
    await per.BlePeripheral.initialize();
    per.BlePeripheral.setAdvertisingStatusUpdateCallback((advertising, error) {
      _advertisingController.add(advertising);
    });
  }

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

    try {
      await per.BlePeripheral.startAdvertising(
        services: [offChatServiceUuid],
        localName: "OffChat Node",
        manufacturerData: per.ManufacturerData(
          manufacturerId: 0xFFFF,
          data: byteData.buffer.asUint8List(),
        ),
      );
    } catch (e) {
      // Log error
    }
  }

  Future<void> stopAdvertising() async {
    await per.BlePeripheral.stopAdvertising();
  }

  Future<void> addService(per.BleService service) async {
    await per.BlePeripheral.addService(service);
  }

  Stream<List<fbp.ScanResult>> get scanResults => fbp.FlutterBluePlus.scanResults;

  Future<void> startScanning() async {
    if (await fbp.FlutterBluePlus.isSupported == false) return;

    // Wait for Bluetooth to be on
    await fbp.FlutterBluePlus.adapterState
        .where((s) => s == fbp.BluetoothAdapterState.on)
        .first;

    await fbp.FlutterBluePlus.startScan(
      withServices: [fbp.Guid(offChatServiceUuid)],
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
      final offChatService = services.firstWhere((s) => s.uuid == fbp.Guid(offChatServiceUuid));
      final char = offChatService.characteristics.firstWhere((c) => c.uuid == fbp.Guid(messageCharUuid));
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
      final offChatService = services.firstWhere((s) => s.uuid == fbp.Guid(offChatServiceUuid));
      final char = offChatService.characteristics.firstWhere((c) => c.uuid == fbp.Guid(imageCharUuid));
      
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
