import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/isar_service.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(Ref ref) async {
  final service = IsarService();
  if (!service.isOpen) {
    await service.initialize();
  }
  return service.db;
}
