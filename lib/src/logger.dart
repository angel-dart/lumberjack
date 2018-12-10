import 'dart:async';
import 'package:meta/meta.dart';
import 'log.dart';
import 'log_severity.dart';

/// A utility that collects [Log] objects, and emits them as a [Stream].
abstract class Logger extends Stream<Log> {
  static Logger get forThisZone {
    var logger = Zone.current[#loggerForThisZone];
    if (logger is Logger) {
      return logger;
    } else {
      throw new StateError(
          'The currently-executing Zone does not have an associated `Logger`.');
    }
  }

  /// Logs a [message] at some [severity].
  @protected
  void log(LogSeverity severity, message,
      {Object error, StackTrace stackTrace});

  /// Logs a [message] at `emergency` [severity].
  void emergency(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.emergency, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `alert` [severity].
  void alert(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.alert, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `critical` [severity].
  void critical(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.critical, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `error` [severity].
  void error(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.error, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `warning` [severity].
  void warning(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.warning, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `message` [severity].
  void message(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.notice, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `information` [severity].
  void information(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.information, message, error: error, stackTrace: stackTrace);
  }

  /// Logs a [message] at `debug` [severity].
  void debug(message, {Object error, StackTrace stackTrace}) {
    log(LogSeverity.debug, message, error: error, stackTrace: stackTrace);
  }
}
