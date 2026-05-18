import 'package:isar_community/isar.dart';
import 'package:off_chat/src/core/background_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/core/database/database_provider.dart';
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
      final isar = await ref.read(isarDatabaseProvider.future);
      
      // Get the existing user directly from Isar to avoid awaiting the provider
      final user = await isar.userModels.where().findFirst();
      
      if (user != null) {
        user.username = username;
        user.profilePicturePath = profilePicturePath;
        user.isOnboarded = true;
        
        _log.info('Saving user profile to Isar...');
        await isar.writeTxn(() => isar.userModels.put(user));
        
        // Initialize background service without blocking the state update
        _log.info('Initializing background service in background...');
        initializeBackgroundService().catchError((e) {
          _log.severe('Background service init failed: $e');
        });
        
        _log.info('Onboarding complete. Updating state.');
        state = const AsyncData(true);
        // Refresh the profile provider to reflect changes in other screens
        ref.invalidate(profileControllerProvider);
      } else {
        _log.severe('Cannot complete onboarding: Current user is null in Isar');
        state = AsyncError('User profile not found', StackTrace.current);
      }
    } catch (e, stack) {
      _log.severe('Failed to complete onboarding: $e', e, stack);
      state = AsyncError(e, stack);
    }
  }
}
