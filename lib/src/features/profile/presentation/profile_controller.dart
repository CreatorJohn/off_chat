import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  FutureOr<UserModel?> build() async {
    final isar = await ref.watch(isarDatabaseProvider.future);
    final user = await isar.userModels.where().findFirst();
    if (user == null) {
      // Create a default user if none exists
      final newUser = UserModel()..username = 'Alex Sterling';
      await isar.writeTxn(() => isar.userModels.put(newUser));
      return newUser;
    }
    return user;
  }

  Future<void> updateUsername(String name) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final user = state.value;
    if (user != null) {
      user.username = name;
      await isar.writeTxn(() => isar.userModels.put(user));
      state = AsyncData(user);
    }
  }

  Future<void> updateProfilePicture(String path) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final user = state.value;
    if (user != null) {
      user.profilePicturePath = path;
      await isar.writeTxn(() => isar.userModels.put(user));
      state = AsyncData(user);
    }
  }

  Future<void> toggleLocationVisibility(bool visible) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final user = state.value;
    if (user != null) {
      user.isLocationVisible = visible;
      await isar.writeTxn(() => isar.userModels.put(user));
      state = AsyncData(user);
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final user = state.value;
    if (user != null) {
      user.isNotificationsEnabled = enabled;
      await isar.writeTxn(() => isar.userModels.put(user));
      state = AsyncData(user);
    }
  }
}
