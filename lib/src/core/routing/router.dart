import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:off_chat/src/features/discovery/presentation/discovery_screen.dart';
import 'package:off_chat/src/features/location/presentation/location_screen.dart';
import 'package:off_chat/src/features/profile/presentation/profile_screen.dart';
import 'package:off_chat/src/features/chat/presentation/chat_screen.dart';
import 'package:off_chat/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:off_chat/src/features/onboarding/presentation/onboarding_controller.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';

part 'router.g.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

@riverpod
GoRouter router(Ref ref) {
  final isOnboardedAsync = ref.watch(onboardingControllerProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      if (isOnboardedAsync.isLoading) return null;
      
      final isOnboarded = isOnboardedAsync.value ?? false;
      final isGoingToOnboarding = state.uri.path == '/onboarding';

      if (!isOnboarded && !isGoingToOnboarding) {
        return '/onboarding';
      }
      if (isOnboarded && isGoingToOnboarding) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DiscoveryScreen(),
          ),
          GoRoute(
            path: '/location',
            builder: (context, state) => const LocationScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/chat/:deviceId',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final deviceId = state.pathParameters['deviceId']!;
          return ChatScreen(deviceId: deviceId);
        },
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.primaryGold.withValues(alpha: 0.2))),
        ),
        child: BottomNavigationBar(
          currentIndex: _calculateSelectedIndex(context),
          onTap: (index) => _onItemTapped(index, context),
          backgroundColor: AppTheme.surfaceBlack,
          selectedItemColor: AppTheme.primaryGold,
          unselectedItemColor: AppTheme.onSurfaceVariant.withValues(alpha: 0.5),
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'RADAR'),
            BottomNavigationBarItem(icon: Icon(Icons.location_on), label: 'NODES'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'IDENTITY'),
          ],
        ),
      ),
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == '/') return 0;
    if (location == '/location') return 1;
    if (location == '/profile') return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/location');
        break;
      case 2:
        GoRouter.of(context).go('/profile');
        break;
    }
  }
}
