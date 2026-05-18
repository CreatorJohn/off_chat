import 'package:isar_community/isar.dart';

part 'relay_task.g.dart';

@Collection()
class RelayTask {
  Id id = Isar.autoIncrement;

  @Index()
  late int targetId;

  @Index()
  late int originId;

  late int messageId;

  late int ttl;

  late List<int> data;

  @Index()
  late DateTime createdAt;

  late int type;

  late List<int> pendingNeighborIds;

  late int sentCount;
}
