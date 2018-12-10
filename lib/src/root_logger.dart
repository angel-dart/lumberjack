import 'dart:async';
import 'log.dart';
import 'logger.dart';

class RootLogger extends Logger {
  final StreamController<Log> _onLog = new StreamController();
}
