import 'package:isar/isar.dart';

part 'message.g.dart';

@Collection()
class Message {
  Id id = Isar.autoIncrement;

  @Index()
  late int senderStableId;

  @Index()
  late int receiverStableId;

  late String content;

  @Index()
  late DateTime timestamp;

  late bool isReceived;

  late bool isImage;

  List<int>? data; // For images or attachments

  int? messageId;

  late bool wasSent;

  late bool isDelivered;

  late bool wasFailed;
}
