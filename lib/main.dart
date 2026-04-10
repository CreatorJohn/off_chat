import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:off_chat/src/app.dart';
import 'package:off_chat/src/core/utils/log_service.dart';
import 'package:off_chat/src/features/chat/data/message_sync_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup logging
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    debugPrint('${record.level.name}: ${record.time}: ${record.message}');
  });

  final container = ProviderContainer();
  // Initialize services
  container.read(logServiceProvider);
  container.read(messageSyncServiceProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const OffChatApp(),
    ),
  );
}
