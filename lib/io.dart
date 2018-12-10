import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:io/ansi.dart';
import 'package:lumberjack/lumberjack.dart';

/// A [StreamConsumer] that prints colorful messages by means of [AnsiCode].
class AnsiLogPrinter extends StreamConsumer<Log> {
  /// Determines which color to use to display a [Log] message.
  final Map<LogSeverity, AnsiCode> colors = {};

  /// The format in which to write the timestamps of [Log] messages.
  ///
  /// Defaults to `yMd_Hms`.
  final DateFormat dateFormat;

  /// The [IOSink] to write to. Oftentimes, this is [stdout].
  final IOSink sink;

  bool _isStdout = false;

  AnsiLogPrinter(this.sink,
      {DateFormat dateFormat, Map<LogSeverity, AnsiCode> colors = const {}})
      : this.dateFormat = dateFormat ?? new DateFormat.yMd().add_Hms() {
    this.colors.addAll({});
    this.colors.addAll(colors ?? {});
  }

  /// Creates an [AnsiLogPrinter] that writes to stdout.
  ///
  /// Does not close [stdout] after [close] is called.
  factory AnsiLogPrinter.toStdout(
          {DateFormat dateFormat,
          Map<LogSeverity, AnsiCode> colors = const {}}) =>
      new AnsiLogPrinter(stdout, colors: colors, dateFormat: dateFormat)
        .._isStdout = true;

  /// Chooses a color based on the logger [severity].
  AnsiCode chooseLogColor(LogSeverity severity) {
    if (severity <= LogSeverity.alert)
      return backgroundRed;
    else if (severity <= LogSeverity.error)
      return red;
    else if (severity <= LogSeverity.warning)
      return yellow;
    else if (severity <= LogSeverity.information)
      return cyan;
    else if (severity == LogSeverity.debug) return lightGray;
    return resetAll;
  }

  @override
  Future addStream(Stream<Log> stream) {
    return stream.forEach((log) {
      if (log.message == null && log.error == null && log.stackTrace == null)
        return;

      var code = chooseLogColor(log.severity);
      var b = new StringBuffer();
      b.write(code.wrap('[${dateFormat.format(log.time)}] '));
      b.write(code.wrap('${log.loggerName}: '));
      b.write(wrapWith('${log.severity.name}', [code, styleBold]));
      if (log.message != null) b.write(code.wrap(log.message.toString()));
      b.writeln();
      if (log.error != null) b.write(code.wrap(log.error.toString()));
      if (log.stackTrace != null) b.write(code.wrap(log.stackTrace.toString()));
      sink.write(b);
    });
  }

  @override
  Future close() {
    if (!_isStdout) return sink.close();
    return new Future.value();
  }
}
