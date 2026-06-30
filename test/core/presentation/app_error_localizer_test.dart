import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/app_error_localizer.dart';

import '../../helpers/localization_test_harness.dart';

/// The presentation-layer mapper: typed [AppErrorCode] -> localized copy, with
/// the backend's [AppException.serverMessage] taking precedence when present.
void main() {
  setUpAll(LocalizationTestHarness.useRealTranslations);

  group('localize', () {
    test('prefers the backend serverMessage when present', () {
      final e = ServerException(
        code: AppErrorCode.loginFailed,
        message: 'Sai mật khẩu rồi bạn ơi',
      );
      expect(AppErrorLocalizer.localize(e), 'Sai mật khẩu rồi bạn ơi');
    });

    test('falls back to the localized code default when no serverMessage', () {
      expect(
        AppErrorLocalizer.localize(
          ServerException(code: AppErrorCode.loginFailed),
        ),
        'Đăng nhập thất bại',
      );
      expect(
        AppErrorLocalizer.localize(
          NetworkException(code: AppErrorCode.networkTimeout),
        ),
        'Kết nối quá thời gian',
      );
      expect(
        AppErrorLocalizer.localize(ServerException()),
        'Lỗi máy chủ',
      );
    });
  });

  group('AppErrorCode.localized', () {
    test('every code maps to a real, non-key translation', () {
      for (final code in AppErrorCode.values) {
        final text = code.localized;
        expect(text, isNotEmpty);
        // A real translation, not the raw key fallback.
        expect(
          text,
          isNot(startsWith('errors.')),
          reason: 'missing copy for $code',
        );
      }
    });
  });
}
