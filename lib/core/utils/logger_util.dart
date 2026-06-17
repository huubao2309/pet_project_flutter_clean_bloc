import 'package:logger/logger.dart';

import 'debug_helper.dart';

final logger = Logger(filter: _LogFilter());

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    final List<Level> debugLevels = [
      Level.debug,
      Level.error,
      Level.info,
      Level.fatal,
      Level.warning,
    ];
    return debugLevels.contains(event.level) && DebugHelper.isDebugMode();
  }
}
