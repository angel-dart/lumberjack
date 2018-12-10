import 'package:lumberjack/lumberjack.dart';

main() async {
  var logger = new Logger('example');
  var foo = logger.createChild('foo');
  var result = await foo.runZoned(() {
    var three = 3.0;
    Logger.forThisZone.emergency('Nooo! It\'s THREE!!!');
  });
}
