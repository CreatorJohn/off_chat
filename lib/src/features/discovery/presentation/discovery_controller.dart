import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/core/database/isar_service.dart';
import 'package:off_chat/src/core/database/models/found_device.dart';

part 'discovery_controller.g.dart';

@riverpod
class DiscoveryController extends _$DiscoveryController {
  @override
  Stream<List<FoundDevice>> build() {
    // Watch the provider to ensure Isar is initialized
    final isarAsync = ref.watch(isarDatabaseProvider);
    
    if (isarAsync.hasValue) {
      return IsarService().watchFoundDevices();
    }
    
    // Return empty stream while initializing
    return const Stream.empty();
  }

  Future<void> manualRefresh() async {
    // Background service handles discovery cycle automatically.
  }
}
