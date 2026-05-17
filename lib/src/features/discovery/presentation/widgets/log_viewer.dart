import 'dart:async';
import 'package:off_chat/src/core/utils/watch_log.dart';
import 'package:off_chat/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart' hide LogRecord;

class LogViewer extends StatefulWidget {
  const LogViewer({super.key});

  @override
  State<LogViewer> createState() => _LogViewerState();
}

class _LogViewerState extends State<LogViewer> {
  final List<LogRecord> logs = [];
  late StreamSubscription<LogRecord> _logListener;

  @override
  void initState() {
    super.initState();

    logs.addAll(WatchLog.logs);

    _logListener = WatchLog.logStream.listen((log) {
      if (mounted) setState(() => logs.add(log));
    });
  }

  Color _getColor(Level level, String loggerName) {
    if (level >= Level.SEVERE) return Colors.red;
    if (level >= Level.WARNING) return Colors.deepOrange;

    if (loggerName.contains('MessageHandler')) return Colors.blue;
    if (loggerName.contains('BLEAdvertiser')) return Colors.orange[800]!;
    if (loggerName.contains('BackgroundService') ||
        loggerName.contains('BLEDiscoverer')) {
      return Colors.teal;
    }
    if (loggerName.contains('ChunkedTransferManager')) return Colors.indigo;
    if (loggerName.contains('ProfileManager')) return Colors.deepPurple;

    if (level == Level.INFO) return Colors.green[700]!;
    if (level <= Level.FINE) return Colors.grey;

    return AppTheme.onSurfaceVariant;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceBlack,
          surfaceTintColor: Colors.transparent,
          constraints: BoxConstraints(
            maxWidth: constrains.maxWidth * 0.95,
            maxHeight: constrains.maxHeight * 0.95,
          ),
          insetPadding: const EdgeInsets.all(8.0),
          titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          title: Row(
            children: [
              const Expanded(
                child: Text(
                  'SYSTEM LOGS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSurfaceVariant,
                    letterSpacing: 2,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_sweep, color: Colors.redAccent, size: 20),
                tooltip: 'Clear',
                onPressed: () {
                  WatchLog.clearLogs();
                  setState(() => logs.clear());
                },
              ),
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.blueAccent, size: 20),
                tooltip: 'Copy',
                onPressed: WatchLog.copyLogsToClipboard,
              ),
              IconButton(
                icon: Icon(Icons.close, color: AppTheme.onSurfaceVariant.withValues(alpha: 0.5), size: 20),
                onPressed: Navigator.of(context).pop,
              ),
            ],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
            side: BorderSide(color: AppTheme.onSurfaceVariant.withValues(alpha: 0.1)),
          ),
          content: Container(
            width: double.maxFinite,
            height: double.maxFinite,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: logs.length,
              itemBuilder: (context, index) {
                final log = logs[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    log.$1,
                    style: TextStyle(
                      color: _getColor(log.$2, log.$3),
                      fontSize: 10,
                      fontFamily: 'monospace',
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _logListener.cancel();
    super.dispose();
  }
}
