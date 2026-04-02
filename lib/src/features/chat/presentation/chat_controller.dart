import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/features/discovery/data/ble_service.dart';
import 'package:off_chat/src/features/chat/domain/message_model.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<List<MessageModel>> build(String remoteDeviceId) async {
    final isar = await ref.watch(isarDatabaseProvider.future);
    
    // Fetch initial messages from database
    return await isar.messageModels
        .filter()
        .senderIdEqualTo(remoteDeviceId)
        .or()
        .receiverIdEqualTo(remoteDeviceId)
        .sortByTimestamp()
        .findAll();
  }

  Future<void> sendTextMessage(String text) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final bleServiceInstance = ref.read(bleServiceProvider);
    
    // 1. Save to Local DB
    final message = MessageModel()
      ..senderId = 'me'
      ..receiverId = remoteDeviceId
      ..content = text
      ..timestamp = DateTime.now()
      ..isRead = true;

    await isar.writeTxn(() => isar.messageModels.put(message));
    
    // 2. Refresh UI
    state = AsyncData([...state.value ?? [], message]);

    // 3. Send over BLE
    try {
      await bleServiceInstance.sendMessage(remoteDeviceId, text);
    } catch (e) {
      // Log error
    }
  }

  Future<void> sendImageMessage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final dir = await getTemporaryDirectory();
    final targetPath = p.join(dir.path, "sent_${DateTime.now().millisecondsSinceEpoch}.jpg");

    final XFile? compressedFile = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      quality: 75,
      minWidth: 512,
      minHeight: 512,
    );

    if (compressedFile == null) return;

    final isar = await ref.read(isarDatabaseProvider.future);
    final bleServiceInstance = ref.read(bleServiceProvider);

    // 1. Save to Local DB
    final message = MessageModel()
      ..senderId = 'me'
      ..receiverId = remoteDeviceId
      ..content = "IMAGE:${compressedFile.path}"
      ..timestamp = DateTime.now()
      ..isRead = true;

    await isar.writeTxn(() => isar.messageModels.put(message));
    state = AsyncData([...state.value ?? [], message]);

    // 2. Send over BLE
    final bytes = await compressedFile.readAsBytes();
    try {
      await bleServiceInstance.sendImage(remoteDeviceId, bytes);
    } catch (e) {
      // Log error
    }
  }
}
