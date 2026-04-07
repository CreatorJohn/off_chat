import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/core/routing/router.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:off_chat/src/features/discovery/presentation/advertising_controller.dart';

class OffChatApp extends ConsumerWidget {
  const OffChatApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    // Start advertising if onboarded
    ref.watch(advertisingControllerProvider);

    return MaterialApp.router(
      title: 'Off Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
