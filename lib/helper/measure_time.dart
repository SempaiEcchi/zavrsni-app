import 'package:firmus/helper/logger.dart';

final _swMap = <String, Stopwatch>{};

void loggerTime(String label) {
  _swMap[label] = Stopwatch()..start();
}

void loggerTimeEnd(String label) {
  if (!_swMap.containsKey(label)) return;
  logger.info("$label took ${_swMap[label]!.elapsedMilliseconds}ms");
}
