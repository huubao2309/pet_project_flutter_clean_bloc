import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared test bootstrap.
///
/// Several production classes resolve their default error messages through
/// easy_localization's context-free `.tr()`. Calling that before the framework
/// binding exists throws, so [ensureTestBinding] initialises just enough for
/// those paths to run inside plain `flutter test` (no widget pumping required).
Future<void> ensureTestBinding() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  // easy_localization's ensureInitialized reads shared_preferences; provide an
  // in-memory mock so it works under plain `flutter test` (no platform plugin).
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
}

/// Marks the binding as initialised for synchronous, non-localized unit tests.
void ensureWidgetsBinding() {
  TestWidgetsFlutterBinding.ensureInitialized();
}
