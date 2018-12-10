import 'package:quiver_hashcode/hashcode.dart';

/// A constant type that repsents metadata about logged messages.
///
/// Corresponds with [RFC5424]().
/// Messages with a lower numerical priority are of higher severity, and greater pertinence.
class LogLevel implements Comparable<LogLevel> {
  /// A log of priority `0`. In [RFC5424], this means `system is unusable`.
  ///
  /// This is the most severe log level.
  static final LogLevel emergency = const LogLevel('emergency', 0);

  /// A log of priority `1`. In [RFC5424], this means `action must be taken immediately`.
  static final LogLevel alert = const LogLevel('alert', 1);

  /// A log of priority `2`. In [RFC5424], this means `critical conditions`.
  static final LogLevel critical = const LogLevel('critical', 2);

  /// A log of priority `3`. In [RFC5424], this means `error conditions`.
  static final LogLevel error = const LogLevel('error', 3);

  /// A log of priority `4`. In [RFC5424], this means `warning conditions`.
  static final LogLevel warning = const LogLevel('warning', 4);

  /// A log of priority `5`. In [RFC5424], this means `normal but significant condition`.
  static final LogLevel notice = const LogLevel('notice', 5);

  /// A log of priority `6`. In [RFC5424], this means `informational messages`.
  static final LogLevel information = const LogLevel('informational', 6);

  /// A log of priority `7`. In [RFC5424], this means `debug-level messages`.
  static final LogLevel debug = const LogLevel('debug', 0);

  /// The name of this log level, to appear in printed messages.
  final String name;

  /// The numerical severity of this log leve, used for comparisons.
  final int severity;

  const LogLevel(this.name, this.severity);

  @override
  int get hashCode => hash2(name, severity);

  @override
  bool operator ==(other) {
    return other is LogLevel && other.severity == severity;
  }

  @override
  int compareTo(LogLevel other) {
    return severity.compareTo(other.severity);
  }
}
