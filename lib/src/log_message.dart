import 'log_level.dart';

/// A message emitted by the system, that should be displayed or stored somewhere.
class LogMessage {
  /// The severity of this message.
  final LogSeverity severity;

  /// The text contents of this message.
  final String message;

  /// The error associated with this object, if any.
  ///
  /// Typically used [stackTrace].
  final Object error;

  /// The [StackTrace] associated with this object, if any.
  ///
  /// Typically used with [error].
  final StackTrace stackTrace;

  LogMessage(this.severity, this.message, this.error, this.stackTrace);
}
