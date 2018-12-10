import 'dart:async';
import 'package:meta/meta.dart';
import 'log.dart';
import 'log_severity.dart';

/// A utility that collects [Log] objects, and emits them as a [Stream].
abstract class Logger extends Stream<Log> {
  /// Returns the [Logger] instance that spawned this [Zone], if any.
  ///
  /// If none is present, a [StateError] will be thrown.
  static Logger get forThisZone {
    var logger = Zone.current[#loggerForThisZone];
    if (logger is Logger) {
      return logger;
    } else {
      throw new StateError(
          'The currently-executing Zone does not have an associated `Logger`.');
    }
  }

  /// Closes the underlying [Stream], and prevents further [Log] messages from being emitted.
  Future close();

  /// Creates a new [Logger] underneath this one, with the given [name].
  ///
  /// [Log] messages from the child will bubble up, prefixed the given [name], followed by a `.`.
  ///
  /// If [bubbleOnly] is `true`, then the child will not emit any events of its own accord, only only
  /// forward messages to this instance.
  Logger createChild(String name, {bool bubbleOnly = false});

  /// Runs [callback] in another [Zone], intercepting [print] calls, and logging errors as they occur.
  ///
  /// Within this callback, [forThisZone] is available.
  ///
  /// You may also provide an [onError] callback, which will be called in case of an error.
  ///
  /// An [errorMessage] string may be provided. If it is not present,
  /// error messages will only have an error and [StackTrace] attached.
  ///
  /// A custom [severityForPrint] may be provided for [print] calls. Defaults to [LogSeverity.information].
  ///
  /// [severityFor] defaults to [LogSeverity.error].
  Future<T> runZoned<T>(FutureOr<T> Function() callback,
      {String errorMessage,
      LogSeverity severityForError = LogSeverity.error,
      LogSeverity severityForPrint = LogSeverity.information,
      FutureOr<T> Function() onError}) {
    var spec = new ZoneSpecification(
      handleUncaughtError: (self, parent, zone, error, stackTrace) {
        log(severityForError, errorMessage,
            error: error, stackTrace: stackTrace);
      },
      print: (self, parent, zone, line) {
        log(severityForPrint, line);
      },
    );
    var zone = Zone.current.fork(specification: spec, zoneValues: {
      #loggerForThisZone: this,
    });

    var future = zone.run(() => new Future<T>.sync(callback));
    return onError == null ? future : future.catchError((_) => onError());
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

  /// Logs a [message] at `notice` [severity].
  void notice(message, {Object error, StackTrace stackTrace}) {
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
