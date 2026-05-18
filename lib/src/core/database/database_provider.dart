import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';
import 'package:off_chat/src/core/database/models/found_device.dart';
import 'package:off_chat/src/core/database/models/message.dart';
import 'package:off_chat/src/core/database/models/relay_task.dart';
import 'package:off_chat/src/core/database/isar_service.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(Ref ref) async {
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      UserModelSchema,
      FoundDeviceSchema,
      MessageSchema,
      RelayTaskSchema,
    ],
    directory: dir.path,
  );
  
  // Initialize the singleton service with this instance
  // Note: IsarService internal initialize opens its own instance if not provided, 
  // but we want to share the same database.
  // Actually, Isar.open is idempotent for the same path/schemas.
  await IsarService().initialize();
  
  return isar;
}
