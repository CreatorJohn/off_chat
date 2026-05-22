import 'package:off_chat/src/features/discovery/data/ble_advertiser.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';

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
Stream<bool> isServiceRunning(Ref ref) {
  final service = FlutterBackgroundService();
  return Stream.periodic(
    const Duration(seconds: 1),
  ).asyncMap((_) => service.isRunning());
}

@riverpod
Stream<Map<String, dynamic>> scanStatus(Ref ref) {
  final service = FlutterBackgroundService();
  return service.on('updateProgress').map((event) => event ?? {});
}

@riverpod
Stream<double> scanProgress(Ref ref) {
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
  final FlutterBackgroundService _bgService = FlutterBackgroundService();

  @override
  Future<String> build() async {
    _bgService.on("updateAdvertisingName").forEach((data) {
      final name = data?["name"];
      if (name is String) state = AsyncData(name);
    });

    final user = await UserModel.load();
    return user?.username ?? "Off Chat Node";
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
    
    // Save to main UserModel (Source of truth)
    final user = await UserModel.load();
    if (user != null) {
      await user.copyWith(username: trimmed).save();
    }

    // Refresh GATT characteristics first
    FlutterBackgroundService().invoke("updateLocalProfile");
    // Then start/update advertising
    FlutterBackgroundService().invoke("startAdvertising", {"name": trimmed});
  }

  Future<void> reset() async {
    final user = await UserModel.load();
    if (user != null) {
      const defaultName = "Off Chat Node";
      state = const AsyncData(defaultName);
      await user.copyWith(username: defaultName).save();
    }
  }
}
