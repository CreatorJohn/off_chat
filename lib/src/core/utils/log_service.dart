import 'dart:async';
import 'package:logging/logging.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'log_service.g.dart';

@Riverpod(keepAlive: true)
class LogService extends _$LogService {
  final List<String> _logs = [];
  final _controller = StreamController<List<String>>.broadcast();

  @override
  List<String> build() {
    // Listen to root logger
    Logger.root.onRecord.listen((record) {
      final logLine = '[${record.level.name}] ${record.time.hour}:${record.time.minute}:${record.time.second}: ${record.message}';
      if (record.error != null) {
        _logs.add('$logLine\nError: ${record.error}');
      } else {
        _logs.add(logLine);
      }
      
      // Keep only last 200 logs
      if (_logs.length > 200) _logs.removeAt(0);
      _controller.add(List.from(_logs));
    });

    return _logs;
  }

  Stream<List<String>> get logStream => _controller.stream;

  void clearLogs() {
    _logs.clear();
    _controller.add([]);
  }
}
