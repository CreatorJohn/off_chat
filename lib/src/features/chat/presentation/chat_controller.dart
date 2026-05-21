import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/core/database/isar_service.dart';
import 'package:off_chat/src/core/database/models/message.dart';
import 'package:off_chat/src/features/chat/data/message_handler.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  Stream<List<Message>> build(String remoteDeviceId) {
    ref.watch(isarDatabaseProvider);
    final stableId = int.parse(remoteDeviceId);
    return IsarService().watchMessagesWithDevice(stableId);
  }

  Future<void> sendTextMessage(String text) async {
    final stableId = int.parse(remoteDeviceId);
    await MessageHandler.sendMessage(targetStableId: stableId, content: text);
  }

  Future<void> sendImageMessage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    
    // Compress image to 128x128 for mesh transfer
    final compressedBytes = await FlutterImageCompress.compressWithList(
      bytes,
      minWidth: 128,
      minHeight: 128,
      quality: 75,
      format: CompressFormat.webp,
    );

    final stableId = int.parse(remoteDeviceId);
    
    // Save locally first
    await MessageHandler.handleOutgoingMessage(
      receiverStableId: stableId,
      content: "[Image]",
      isImage: true,
      imageData: Uint8List.fromList(compressedBytes),
    );
    
    // MessageHandler will automatically pick up unsent messages in pushQueuedDataToPeer 
    // when it next meets this peer. 
    // But we can trigger a manual sync via background service if we want immediate attempt.
    // For now, let the core logic handle it.
  }
}
