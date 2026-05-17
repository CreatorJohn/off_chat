import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/core/routing/router.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class OffChatApp extends ConsumerStatefulWidget {
  const OffChatApp({super.key});

  @override
  ConsumerState<OffChatApp> createState() => _OffChatAppState();
}

class _OffChatAppState extends ConsumerState<OffChatApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Notify service that app is active
    Future.delayed(const Duration(seconds: 1), () => _setOnlineStatus(true));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setOnlineStatus(true);
    } else {
      _setOnlineStatus(false);
    }
  }

  void _setOnlineStatus(bool isOnline) {
    FlutterBackgroundService().invoke("setOnlineStatus", {
      "isOnline": isOnline,
    });
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Off Chat',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
