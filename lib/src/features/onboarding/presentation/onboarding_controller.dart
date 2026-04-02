import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  FutureOr<bool> build() async {
    final user = await ref.watch(profileControllerProvider.future);
    return user?.isOnboarded ?? false;
  }

  Future<void> completeOnboarding({required String username, String? profilePicturePath}) async {
    final isar = await ref.read(isarDatabaseProvider.future);
    final user = await ref.read(profileControllerProvider.future);
    
    if (user != null) {
      user.username = username;
      user.profilePicturePath = profilePicturePath;
      user.isOnboarded = true;
      
      await isar.writeTxn(() => isar.userModels.put(user));
      ref.invalidate(profileControllerProvider);
      state = const AsyncData(true);
    }
  }
}
