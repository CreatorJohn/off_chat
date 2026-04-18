import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:ble_peripheral/ble_peripheral.dart' as per;
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ble_service.g.dart';

final _log = Logger('BleService');

// Response status codes
const int successStatusCode = 0;
const int invalidCharacteristicStatusCode = 1;
const int invalidMessageTypeStatusCode = 2;
const int missingDataStatusCode = 3;

// Message types
const int startChunkCode = 0;
const int dataChunkCode = 1;
const int endChunkCode = 2;

// Identifiers
const String offChatServiceUuid = "4a1a5fc0-67a4-4a4c-83b3-8a301bd9b210";
const String identityCharUuid = "4a1a5fc1-67a4-4a4c-83b3-8a301bd9b210";
const String messageCharUuid = "4a1a5fc2-67a4-4a4c-83b3-8a301bd9b210";
const String imageCharUuid = "4a1a5fc3-67a4-4a4c-83b3-8a301bd9b210";

class OffChatBleService {
  final _messageController =
      StreamController<({String senderId, String text})>.broadcast();
  final _imageController =
      StreamController<({String senderId, Uint8List imageBytes})>.broadcast();
  final _advertisingController = StreamController<bool>.broadcast();

  // Device → Characteristic → Data
  final _incomingData = <String, Map<String, Uint8List>>{};

  bool _isInitialized = false;
  bool _isStarting = false;
  bool _isServiceAdded = false;

  Stream<({String senderId, String text})> get incomingMessages =>
      _messageController.stream;
  Stream<({String senderId, Uint8List imageBytes})> get incomingImages =>
      _imageController.stream;

  Stream<bool> get isScanning => fbp.FlutterBluePlus.isScanning;
  Stream<bool> get isAdvertising => _advertisingController.stream;

  OffChatBleService() {
    // Service is initialized manually after permissions are granted
  }

  Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      _log.info('Initializing BlePeripheral...');
      await per.BlePeripheral.initialize();
      _isInitialized = true;
      _log.info('BlePeripheral initialized.');

      per.BlePeripheral.setAdvertisingStatusUpdateCallback((
        advertising,
        error,
      ) {
        if (error != null) {
          _log.severe('Advertising status error: $error');
        }
        _log.info('Advertising status update: $advertising');
        _advertisingController.add(advertising);
      });

      per.BlePeripheral.setBleStateChangeCallback((state) {
        _log.info('Bluetooth state changed: $state');
      });

      per.BlePeripheral.setWriteRequestCallback((
        deviceId,
        characteristicId,
        offset,
        value,
      ) {
        /*
          TODO: Implement receiving (sending) data protocol

          Received data → TYPE,CONTENT
          TYPE → START, DATA, END
        */

        _log.info(
          'GATT Write from $deviceId to $characteristicId. Value len: ${value?.length}',
        );

        // Missing value
        if (value == null || value.length < 2) {
          return per.WriteRequestResult(status: missingDataStatusCode);
        }

        // Invalid characteristic
        if (characteristicId != messageCharUuid &&
            characteristicId != imageCharUuid) {
          return per.WriteRequestResult(
            status: invalidCharacteristicStatusCode,
          );
        }

        final [type, ...content] = value;

        switch (type) {
          case startChunkCode: // First data chunk
            _handleStartChunk(
              deviceId,
              characteristicId,
              Uint8List.fromList(content),
            );

            break;
          case dataChunkCode: // Other data chunks
            if (!_handleDataChunk(deviceId, characteristicId, content)) {
              return per.WriteRequestResult(
                status: invalidMessageTypeStatusCode,
              );
            }

            break;
          case endChunkCode: // Last data chunk
            if (!_handleLastChunk(deviceId, characteristicId, content)) {
              return per.WriteRequestResult(
                status: invalidMessageTypeStatusCode,
              );
            }

            break;
          default: // Invalid message type
            return per.WriteRequestResult(status: invalidMessageTypeStatusCode);
        }

        return per.WriteRequestResult(status: successStatusCode);
      });
    } catch (e) {
      _log.severe('Failed to initialize BlePeripheral: $e');
    }
  }

  void _handleStartChunk(String deviceId, String charId, Uint8List content) {
    _incomingData.update(deviceId, (chars) {
      chars[charId] = Uint8List.fromList(content);

      return chars;
    }, ifAbsent: () => {charId: Uint8List.fromList(content)});
  }

  bool _handleDataChunk(String deviceId, String charId, List<int> content) {
    if (_incomingData[deviceId]?.containsKey(charId) == false) {
      return false;
    }

    _incomingData.update(deviceId, (oldChar) {
      oldChar.update(
        charId,
        (oldData) => Uint8List.fromList([...oldData, ...content]),
      );

      return oldChar;
    });

    return true;
  }

  bool _handleLastChunk(String deviceId, String charId, List<int> content) {
    if (_incomingData[deviceId]?.containsKey(charId) == false) {
      return false;
    }

    final fullContent = Uint8List.fromList([
      ..._incomingData[deviceId]![charId]!,
      ...content,
    ]);

    _incomingData.update(deviceId, (oldChar) {
      oldChar.remove(charId);

      return oldChar;
    });

    switch (charId) {
      case messageCharUuid:
        final text = utf8.decode(fullContent);

        handleIncomingMessage(deviceId, text);

        break;
      case imageCharUuid:
        handleIncomingImage(deviceId, fullContent);
        break;
    }

    return true;
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
    if (!_isInitialized) {
      await initialize();
    }

    if (_isStarting) {
      _log.info('Advertising already in progress, skipping start request.');
      return;
    }
    _isStarting = true;

    final ByteData byteData = ByteData(13);
    int flags = 0;
    if (platformFlag == 1) flags |= (1 << 0);
    if (isLocationVisible) flags |= (1 << 1);
    byteData.setUint8(0, flags);
    byteData.setUint32(1, profileHash, Endian.little);
    byteData.setFloat32(5, latitude, Endian.little);
    byteData.setFloat32(9, longitude, Endian.little);

    _log.info(
      'Preparing to advertise. Payload: ${byteData.buffer.asUint8List()}',
    );

    try {
      // Clear previous advertising
      await per.BlePeripheral.stopAdvertising();
      // Small delay to let the OS clean up
      await Future.delayed(const Duration(milliseconds: 500));

      await per.BlePeripheral.startAdvertising(
        services: [offChatServiceUuid],
        localName: null,
        manufacturerData: per.ManufacturerData(
          manufacturerId: 0xFFFF,
          data: byteData.buffer.asUint8List(),
        ),
        addManufacturerDataInScanResponse: true,
      );
      _log.info('BlePeripheral.startAdvertising successfully initiated.');
    } catch (e) {
      _log.severe('Error starting advertising: $e');
    } finally {
      _isStarting = false;
    }
  }

  Future<void> stopAdvertising() async {
    await per.BlePeripheral.stopAdvertising();
  }

  Future<void> addService(per.BleService service) async {
    if (_isServiceAdded) {
      _log.info('Service already added, cleaning first.');

      await per.BlePeripheral.clearServices();
    }
    await per.BlePeripheral.addService(service);
    _isServiceAdded = true;
    _log.info('Service added successfully.');
  }

  Stream<List<fbp.ScanResult>> get scanResults =>
      fbp.FlutterBluePlus.scanResults;

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

      // Request higher MTU if possible
      if (Platform.isAndroid) {
        await device.requestMtu(512);
      }

      final services = await device.discoverServices();
      final offChatService = services.firstWhere(
        (s) => s.uuid == fbp.Guid(offChatServiceUuid),
      );
      final char = offChatService.characteristics.firstWhere(
        (c) => c.uuid == fbp.Guid(messageCharUuid),
      );

      final bytes = Uint8List.fromList(utf8.encode(text));
      final mtu = await device.mtu.first;

      int offset = 0;

      while (offset < bytes.length) {
        int end = offset + mtu - 4;
        int type;

        if (end >= bytes.length) {
          type = endChunkCode;
        } else if (offset == 0) {
          type = startChunkCode;
        } else {
          type = dataChunkCode;
        }

        if (end > bytes.length) end = bytes.length;
        await char.write([
          type,
          ...bytes.sublist(offset, end),
        ], withoutResponse: false);
        offset = end;
      }

      _log.info('Message sent to $remoteId');
    } catch (e) {
      _log.severe('Failed to send message to $remoteId: $e');
    } finally {
      await device.disconnect();
    }
  }

  Future<void> sendImage(String remoteId, Uint8List imageBytes) async {
    final device = fbp.BluetoothDevice.fromId(remoteId);
    try {
      await device.connect(license: fbp.License.free);
      final services = await device.discoverServices();
      final offChatService = services.firstWhere(
        (s) => s.uuid == fbp.Guid(offChatServiceUuid),
      );
      final char = offChatService.characteristics.firstWhere(
        (c) => c.uuid == fbp.Guid(imageCharUuid),
      );

      int mtu = await device.mtu.first;
      int offset = 0;

      while (offset < imageBytes.length) {
        int end = offset + mtu - 4;
        int type;

        if (end >= imageBytes.length) {
          type = endChunkCode;
        } else if (offset == 0) {
          type = startChunkCode;
        } else {
          type = dataChunkCode;
        }

        if (end > imageBytes.length) end = imageBytes.length;
        await char.write([
          type,
          ...imageBytes.sublist(offset, end),
        ], withoutResponse: true);
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
