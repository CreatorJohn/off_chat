import 'package:off_chat/src/features/discovery/data/ble_advertiser.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'advertising_state.g.dart';

@riverpod
class CanAdvertise extends _$CanAdvertise {
  final FlutterBackgroundService _service = FlutterBackgroundService();

  @override
  bool? build() {
    _service.on("advertisingSupported").listen((event) {
      bool? supported = event?["value"];
      if (supported == null) return;
      state = supported;
    });

    return null;
  }
}

@riverpod
class IsAdvertising extends _$IsAdvertising {
  final FlutterBackgroundService _service = FlutterBackgroundService();
  static const String _adKey = 'advertising_on';

  @override
  bool build() {
    _service.on("advertisingChange").listen((event) {
      final bool? active = event?["active"];
      if (active != null) state = active;
    });

    _loadInitial();
    return false;
  }

  Future<void> _loadInitial() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool(_adKey) ?? false;
  }
}

@riverpod
Stream<bool> isServiceRunning(IsServiceRunningRef ref) {
  final service = FlutterBackgroundService();
  return Stream.periodic(
    const Duration(seconds: 1),
  ).asyncMap((_) => service.isRunning());
}

@riverpod
Stream<Map<String, dynamic>> scanStatus(ScanStatusRef ref) {
  final service = FlutterBackgroundService();
  return service.on('updateProgress').map((event) => event ?? {});
}

@riverpod
Stream<double> scanProgress(ScanProgressRef ref) {
  final service = FlutterBackgroundService();
  return service.on('updateProgress').map((event) {
    final value = event?['value'];
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return 0.0;
  });
}

@riverpod
class AdvertisingName extends _$AdvertisingName {
  static const String _storageKey = 'advertising_name_v2';
  final String _defaultName = "Off Chat Node";
  final FlutterBackgroundService _bgService = FlutterBackgroundService();

  @override
  Future<String> build() async {
    final prefs = await SharedPreferences.getInstance();

    _bgService.on("updateAdvertisingName").forEach((data) {
      final name = data?["name"];
      if (name is String) state = AsyncData(name);
    });

    return prefs.getString(_storageKey) ?? _defaultName;
  }

  Future<void> change(String newName) async {
    final trimmed = newName.trim();
    if (trimmed.length > BLEAdvertiser.maxNameLength) {
      state = AsyncError(
        "Name exceeds BLE limits (max ${BLEAdvertiser.maxNameLength})",
        StackTrace.current,
      );
      return;
    }

    state = AsyncData(trimmed);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, trimmed);

    // Refresh GATT characteristics first
    FlutterBackgroundService().invoke("updateLocalProfile");
    // Then start/update advertising
    FlutterBackgroundService().invoke("startAdvertising", {"name": trimmed});
  }

  Future<void> reset() async {
    state = AsyncData(_defaultName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
