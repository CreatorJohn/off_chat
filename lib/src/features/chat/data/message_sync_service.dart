import 'dart:io';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/core/notifications/notification_service.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';
import 'package:off_chat/src/features/discovery/domain/discovered_device_model.dart';
import 'package:off_chat/src/features/chat/domain/message_model.dart';

part 'message_sync_service.g.dart';

@Riverpod(keepAlive: true)
class MessageSyncService extends _$MessageSyncService {
  @override
  void build() {
    final bleServiceInstance = ref.watch(bleServiceProvider);
    
    // Listen for incoming text messages
    bleServiceInstance.incomingMessages.listen((data) {
      _saveMessage(data.senderId, data.text);
    });

    // Listen for incoming image chunks/bytes
    bleServiceInstance.incomingImages.listen((data) {
      _saveImage(data.senderId, data.imageBytes);
    });
  }

  Future<void> _saveMessage(String senderId, String text) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final notificationServiceInstance = ref.read(notificationServiceProvider);

    final message = MessageModel()
      ..senderId = senderId
      ..receiverId = 'me'
      ..content = text
      ..timestamp = DateTime.now()
      ..isRead = false;

    // Check if first time
    final device = await isar.discoveredDeviceModels.where().deviceIdEqualTo(senderId).findFirst();
    bool isFirstTime = device == null || !device.hasMessagedBefore;

    await isar.writeTxn(() async {
      await isar.messageModels.put(message);
      if (device != null) {
        device.hasMessagedBefore = true;
        await isar.discoveredDeviceModels.put(device);
      }
    });

    // Show Notification
    await notificationServiceInstance.showMessageNotification(
      senderName: device?.username ?? "Unknown Node",
      message: text,
      isFirstTime: isFirstTime,
    );
  }

  Future<void> _saveImage(String senderId, List<int> bytes) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final notificationServiceInstance = ref.read(notificationServiceProvider);

    final dir = await getApplicationDocumentsDirectory();
    final imagePath = p.join(dir.path, "received_${DateTime.now().millisecondsSinceEpoch}.jpg");
    await File(imagePath).writeAsBytes(bytes);

    final message = MessageModel()
      ..senderId = senderId
      ..receiverId = 'me'
      ..content = "IMAGE:$imagePath"
      ..timestamp = DateTime.now()
      ..isRead = false;

    final device = await isar.discoveredDeviceModels.where().deviceIdEqualTo(senderId).findFirst();
    bool isFirstTime = device == null || !device.hasMessagedBefore;

    await isar.writeTxn(() async {
      await isar.messageModels.put(message);
      if (device != null) {
        device.hasMessagedBefore = true;
        await isar.discoveredDeviceModels.put(device);
      }
    });

    await notificationServiceInstance.showMessageNotification(
      senderName: device?.username ?? "Unknown Node",
      message: "Sent you an image",
      isFirstTime: isFirstTime,
    );
  }
}
