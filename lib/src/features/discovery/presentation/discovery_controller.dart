import 'dart:async';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/core/database/isar_service.dart';
import 'package:off_chat/src/core/database/models/found_device.dart';

part 'discovery_controller.g.dart';

@riverpod
Stream<List<FoundDevice>> watchFoundDevices(Ref ref) {
  ref.watch(isarDatabaseProvider);
  return IsarService().watchFoundDevices();
}

@riverpod
Stream<FoundDevice?> watchDevice(Ref ref, int stableId) {
  ref.watch(isarDatabaseProvider);
  return IsarService().db.foundDevices
      .filter()
      .stableIdEqualTo(stableId)
      .watch(fireImmediately: true)
      .map((list) => list.isNotEmpty ? list.first : null);
}

@riverpod
class DiscoveryController extends _$DiscoveryController {
  @override
  Stream<List<FoundDevice>> build() {
    ref.watch(isarDatabaseProvider);
    return IsarService().watchFoundDevices();
  }

  Future<void> manualRefresh() async {
    // Background service handles discovery cycle automatically.
  }
}
