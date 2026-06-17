import 'package:flutter/foundation.dart';

/// Small helper to gate debug-only behaviour (e.g. verbose logging).
///
/// Ported from the source app and de-GetX'd: instead of inspecting the GetX
/// environment, it relies on Flutter's compile-time [kDebugMode] flag.
class DebugHelper {
  const DebugHelper._();

  static bool isDebugMode() => kDebugMode;
}
