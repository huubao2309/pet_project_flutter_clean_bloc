import 'localization_test_harness.dart';

/// Back-compat shim. Prefer [LocalizationTestHarness] directly in new tests:
///   • `LocalizationTestHarness.useKeys` — `.tr()` returns the key (model/VM tests)
///   • `LocalizationTestHarness.useRealTranslations` — real copy (widget/screen tests)
///   • `LocalizationTestHarness.useFake({...})` — inject specific translations
///
/// [ensureTestBinding] maps to the keys-only mode, which is what the existing
/// model / view-model tests rely on (assert on the translation key).
Future<void> ensureTestBinding() => LocalizationTestHarness.useKeys();
