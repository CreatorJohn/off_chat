import 'package:isar/isar.dart';

part 'message_model.g.dart';

@collection
class MessageModel {
  Id id = Isar.autoIncrement;

  @Index()
  late String senderId;

  @Index()
  late String receiverId;

  late String content;

  @Index()
  late DateTime timestamp;

  bool isRead = false;
}
