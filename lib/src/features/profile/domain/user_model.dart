import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  static const String _profileKey = 'user_profile_json';

  String? deviceId;
  String username;
  String? profilePicturePath;
  bool isLocationVisible;
  bool isNotificationsEnabled;
  bool notifyNewUserIdentified;
  bool notifyFirstMessage;
  bool notifySubsequentMessages;
  bool isOnboarded;

  UserModel({
    this.deviceId,
    required this.username,
    this.profilePicturePath,
    this.isLocationVisible = true,
    this.isNotificationsEnabled = true,
    this.notifyNewUserIdentified = true,
    this.notifyFirstMessage = true,
    this.notifySubsequentMessages = true,
    this.isOnboarded = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceId': deviceId,
      'username': username,
      'profilePicturePath': profilePicturePath,
      'isLocationVisible': isLocationVisible,
      'isNotificationsEnabled': isNotificationsEnabled,
      'notifyNewUserIdentified': notifyNewUserIdentified,
      'notifyFirstMessage': notifyFirstMessage,
      'notifySubsequentMessages': notifySubsequentMessages,
      'isOnboarded': isOnboarded,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      deviceId: json['deviceId'],
      username: json['username'] ?? 'Alex Sterling',
      profilePicturePath: json['profilePicturePath'],
      isLocationVisible: json['isLocationVisible'] ?? true,
      isNotificationsEnabled: json['isNotificationsEnabled'] ?? true,
      notifyNewUserIdentified: json['notifyNewUserIdentified'] ?? true,
      notifyFirstMessage: json['notifyFirstMessage'] ?? true,
      notifySubsequentMessages: json['notifySubsequentMessages'] ?? true,
      isOnboarded: json['isOnboarded'] ?? false,
    );
  }

  UserModel copyWith({
    String? deviceId,
    String? username,
    String? profilePicturePath,
    bool? isLocationVisible,
    bool? isNotificationsEnabled,
    bool? notifyNewUserIdentified,
    bool? notifyFirstMessage,
    bool? notifySubsequentMessages,
    bool? isOnboarded,
  }) {
    return UserModel(
      deviceId: deviceId ?? this.deviceId,
      username: username ?? this.username,
      profilePicturePath: profilePicturePath ?? this.profilePicturePath,
      isLocationVisible: isLocationVisible ?? this.isLocationVisible,
      isNotificationsEnabled: isNotificationsEnabled ?? this.isNotificationsEnabled,
      notifyNewUserIdentified: notifyNewUserIdentified ?? this.notifyNewUserIdentified,
      notifyFirstMessage: notifyFirstMessage ?? this.notifyFirstMessage,
      notifySubsequentMessages: notifySubsequentMessages ?? this.notifySubsequentMessages,
      isOnboarded: isOnboarded ?? this.isOnboarded,
    );
  }

  static Future<UserModel?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_profileKey);
    if (json == null) return null;
    return UserModel.fromJson(jsonDecode(json));
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(toJson()));
  }
}
