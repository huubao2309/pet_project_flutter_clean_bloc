import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';

import 'localization_test_harness.dart';

/// Proves the harness makes `.tr()` resolve deterministically in a plain
/// `flutter test` (no widget pumping), in each of its three modes.
void main() {
  group('useKeys', () {
    setUpAll(LocalizationTestHarness.useKeys);

    test('.tr() returns the key unchanged', () {
      expect('errors.server'.tr(), 'errors.server');
      expect('home.see_all'.tr(), 'home.see_all');
    });
  });

  group('useRealTranslations', () {
    setUpAll(LocalizationTestHarness.useRealTranslations);

    test('.tr() returns the real Vietnamese copy from assets', () {
      expect('errors.server'.tr(), 'Lỗi máy chủ');
      expect('home.see_all'.tr(), 'Xem tất cả');
    });

    test('a missing key falls back to the key string', () {
      expect('home.listings'.tr(), 'home.listings');
    });
  });

  group('useFake', () {
    setUpAll(() => LocalizationTestHarness.useFake({
          'errors': {'server': 'BOOM'},
        }),);

    test('.tr() resolves only the injected fake map', () {
      expect('errors.server'.tr(), 'BOOM');
      // Keys outside the fake map fall back to the key string.
      expect('home.see_all'.tr(), 'home.see_all');
    });
  });
}
