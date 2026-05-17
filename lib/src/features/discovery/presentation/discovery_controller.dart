import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/isar_service.dart';
import 'package:off_chat/src/core/database/models/found_device.dart';

part 'discovery_controller.g.dart';

@riverpod
class DiscoveryController extends _$DiscoveryController {
  @override
  Stream<List<FoundDevice>> build() {
    return IsarService().watchFoundDevices();
  }

  Future<void> manualRefresh() async {
    // Background service handles discovery cycle automatically.
    // We could potentially trigger a manual scan via service invoke if needed.
  }
}
