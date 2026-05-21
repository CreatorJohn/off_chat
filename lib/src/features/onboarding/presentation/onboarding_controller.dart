import 'package:off_chat/src/core/background_service.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/profile/presentation/profile_controller.dart';
import 'package:off_chat/src/features/profile/domain/user_model.dart';
import 'package:logging/logging.dart';

part 'onboarding_controller.g.dart';

@riverpod
class OnboardingController extends _$OnboardingController {
  static final _log = Logger('OnboardingController');

  @override
  FutureOr<bool> build() async {
    final user = await ref.watch(profileControllerProvider.future);
    final isOnboarded = user?.isOnboarded ?? false;
    if (isOnboarded) {
      _log.info('User already onboarded, ensuring service is running');
      await initializeBackgroundService().catchError((e) {
        _log.severe('Failed to auto-start background service: $e');
      });
    }
    return isOnboarded;
  }

  Future<void> completeOnboarding({required String username, String? profilePicturePath}) async {
    state = const AsyncLoading();
    try {
      _log.info('Completing onboarding for user: $username');
      
      // Get the existing user
      var user = await UserModel.load();
      
      if (user == null) {
        _log.info('No user found, creating new one for onboarding');
        user = UserModel(username: username);
      }

      user.username = username;
      user.profilePicturePath = profilePicturePath;
      user.isOnboarded = true;
      
      _log.info('Saving user profile to SharedPreferences...');
      await user.save();
      
      // Initialize background service without blocking the state update
      _log.info('Initializing background service in background...');
      initializeBackgroundService().then((_) {
        _log.info('Service initialized, triggering startAdvertising...');
        FlutterBackgroundService().invoke("startAdvertising", {"name": username});
      }).catchError((e) {
        _log.severe('Background service init failed: $e');
      });
      
      _log.info('Onboarding complete. Updating state.');
      state = const AsyncData(true);
      // Refresh the profile provider to reflect changes in other screens
      ref.invalidate(profileControllerProvider);
    } catch (e, stack) {
      _log.severe('Failed to complete onboarding: $e', e, stack);
      state = AsyncError(e, stack);
    }
  }
}
