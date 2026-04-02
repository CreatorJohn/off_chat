import 'package:isar/isar.dart';

part 'discovered_device_model.g.dart';

@collection
class DiscoveredDeviceModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String deviceId; // BLE MAC or UUID

  String? username;

  String? profilePicturePath;

  DateTime? lastDiscovered;

  double? latitude;

  double? longitude;

  bool hasMessagedBefore = false;
}
