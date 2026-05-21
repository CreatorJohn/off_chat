import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/isar_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'database_provider.g.dart';

@Riverpod(keepAlive: true)
Future<Isar> isarDatabase(Ref ref) async {
  final service = IsarService();
  if (!service.isOpen) {
    await service.initialize();
  }
  return service.db;
}

@Riverpod(keepAlive: true)
Future<SharedPreferences> sharedPreferences(Ref ref) {
  return SharedPreferences.getInstance();
}
