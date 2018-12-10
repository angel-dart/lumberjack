import 'package:quiver_hashcode/hashcode.dart';

/// A constant type that repsents metadata about logged messages.
class LogLevel implements Comparable<LogLevel> {
  /// The name of this log level, to appear in printed messages.
  final String name;

  /// The numerical value of this log leve, used for comparisons.
  final int value;

  const LogLevel(this.name, this.value);

  @override
  int get hashCode => hash2(name, value);

  @override
  bool operator ==(other) {
    return other is LogLevel && other.value == value;
  }

  @override
  int compareTo(LogLevel other) {
    return value.compareTo(other.value);
  }
}
