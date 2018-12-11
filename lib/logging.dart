import 'package:logging/logging.dart' as dart;
import 'src/root_logger.dart';
import 'lumberjack.dart';

/// A [Logger] that wraps a [dart.Logger] from `package:logging`.
class ConvertingLogger extends RootLogger {
  final dart.Logger logger;

  /// Translates a [level] into a [LogSeverity].
  static LogSeverity convertLevel(dart.Level level) {
    if (level == dart.Level.SHOUT) return LogSeverity.emergency;
    if (level == dart.Level.SEVERE) return LogSeverity.error;
    if (level == dart.Level.WARNING) return LogSeverity.warning;
    if (level == dart.Level.INFO) return LogSeverity.information;
    if (level == dart.Level.FINE ||
        level == dart.Level.FINER ||
        level == dart.Level.FINEST)
      return LogSeverity.debug;
    else
      return LogSeverity.information;
  }

  ConvertingLogger(this.logger) : super(logger.fullName) {
    logger.onRecord.listen((rec) {
      var log = new Log(rec.loggerName, rec.time, convertLevel(rec.level),
          rec.message, rec.error, rec.stackTrace);
      add(log);
    });
  }

  @override
  Future close() {
    logger.clearListeners();
    return super.close();
  }
}
