import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';
import 'package:off_chat/src/features/discovery/domain/discovered_device_model.dart';
import 'package:off_chat/src/features/chat/domain/message_model.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(IsarDatabaseRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [UserModelSchema, DiscoveredDeviceModelSchema, MessageModelSchema],
    directory: dir.path,
  );
}
