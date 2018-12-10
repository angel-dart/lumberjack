import 'hierarchical_logger.dart';
import 'log.dart';

class ChildLogger extends HierarchicalLogger {
  final HierarchicalLogger parent;
  final bool bubbleOnly;

  ChildLogger(this.parent, String name, this.bubbleOnly) : super(name);

  @override
  void add(Log log) {
    super.add(log);

    if (!bubbleOnly) {
      var msg = new Log('${parent.name}.$name', log.time, log.severity,
          log.message, log.error, log.stackTrace);
      parent.add(msg);
    }
  }
}
