import 'dart:async';
import 'package:meta/meta.dart';

import 'child_logger.dart';
import 'log_severity.dart';
import 'log.dart';
import 'logger.dart';

/// A base [Logger] that is aware of its children.
abstract class HierarchicalLogger extends Logger {
  final String name;
  final List<Logger> _children = [];

  final StreamController<Log> _onLog = new StreamController();

  HierarchicalLogger(this.name) : super.base();

  @override
  StreamSubscription<Log> listen(void Function(Log event) onData,
      {Function onError, void Function() onDone, bool cancelOnError}) {
    return _onLog.stream.listen(onData,
        onError: onError, onDone: onDone, cancelOnError: cancelOnError);
  }

  void log(LogSeverity severity, message,
      {Object error, StackTrace stackTrace}) {
    add(new Log(
        name, new DateTime.now(), severity, message, error, stackTrace));
  }

  /// Emit a [Log] message.
  @protected
  void add(Log log) {
    if (!_onLog.isClosed) {
      _onLog.add(log);
    }
  }

  @override
  Logger createChild(String name, {bool bubbleOnly = false}) {
    var child = new ChildLogger(this, name, bubbleOnly);
    _children.add(child);
    return child;
  }

  @override
  Future close() {
    _children.forEach((c) => c.close());
    _onLog.close();
    return new Future.value();
  }
}
