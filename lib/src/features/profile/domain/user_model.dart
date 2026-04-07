import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? deviceId;

  late String username;

  String? profilePicturePath;

  bool isLocationVisible = true;

  bool isNotificationsEnabled = true;

  bool isOnboarded = false;
}
