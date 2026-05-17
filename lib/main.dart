import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:off_chat/src/app.dart';
import 'package:off_chat/src/core/utils/watch_log.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup hardened logging
  await WatchLog.initialize();

  final container = ProviderContainer();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const OffChatApp(),
    ),
  );
}
