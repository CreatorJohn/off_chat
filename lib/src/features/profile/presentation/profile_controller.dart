import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';
import 'package:logging/logging.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  static final _log = Logger('ProfileController');
  static const _profileKey = 'user_profile_json';

  @override
  FutureOr<UserModel?> build() async {
    _log.info('Building ProfileController...');
    final prefs = await ref.watch(sharedPreferencesProvider.future);
    final profileJson = prefs.getString(_profileKey);
    
    if (profileJson == null) {
      _log.info('No user found, creating default profile...');
      final newUser = UserModel(username: 'Alex Sterling');
      await prefs.setString(_profileKey, jsonEncode(newUser.toJson()));
      return newUser;
    }
    
    _log.info('Profile loaded from SharedPreferences');
    return UserModel.fromJson(jsonDecode(profileJson));
  }

  Future<void> _saveProfile(UserModel user) async {
    final prefs = await ref.read(sharedPreferencesProvider.future);
    await prefs.setString(_profileKey, jsonEncode(user.toJson()));
    state = AsyncData(user);
  }

  Future<void> updateUsername(String name) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(username: name));
    }
  }

  Future<void> updateProfilePicture(String path) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(profilePicturePath: path));
    }
  }

  Future<void> toggleLocationVisibility(bool visible) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(isLocationVisible: visible));
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(isNotificationsEnabled: enabled));
    }
  }

  Future<void> toggleNotifyNewUserIdentified(bool enabled) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(notifyNewUserIdentified: enabled));
    }
  }

  Future<void> toggleNotifyFirstMessage(bool enabled) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(notifyFirstMessage: enabled));
    }
  }

  Future<void> toggleNotifySubsequentMessages(bool enabled) async {
    final user = state.value;
    if (user != null) {
      await _saveProfile(user.copyWith(notifySubsequentMessages: enabled));
    }
  }
}
