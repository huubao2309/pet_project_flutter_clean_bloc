import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/auth_block_verdict.dart';

void main() {
  group('blockReasonFromVerdict', () {
    test('maps otp_limit_exceeded to BlockReason.otpLimitExceeded', () {
      expect(
        blockReasonFromVerdict('otp_limit_exceeded'),
        BlockReason.otpLimitExceeded,
      );
    });

    test('maps account_is_deleted to BlockReason.accountDeleted', () {
      expect(
        blockReasonFromVerdict('account_is_deleted'),
        BlockReason.accountDeleted,
      );
    });

    test('returns null for null verdict', () {
      expect(blockReasonFromVerdict(null), isNull);
    });

    test('returns null for an unknown verdict', () {
      expect(blockReasonFromVerdict('something_else'), isNull);
    });

    test('returns null for an empty string', () {
      expect(blockReasonFromVerdict(''), isNull);
    });

    test('returns null for phone_is_blocked (not an account block)', () {
      expect(blockReasonFromVerdict('phone_is_blocked'), isNull);
    });

    test('mapping is exact (case sensitive)', () {
      expect(blockReasonFromVerdict('OTP_LIMIT_EXCEEDED'), isNull);
    });
  });

  group('isPhoneBlockedVerdict', () {
    test('true only for phone_is_blocked', () {
      expect(isPhoneBlockedVerdict('phone_is_blocked'), isTrue);
    });

    test('false for null', () {
      expect(isPhoneBlockedVerdict(null), isFalse);
    });

    test('false for empty string', () {
      expect(isPhoneBlockedVerdict(''), isFalse);
    });

    test('false for other verdicts', () {
      expect(isPhoneBlockedVerdict('otp_limit_exceeded'), isFalse);
      expect(isPhoneBlockedVerdict('account_is_deleted'), isFalse);
    });

    test('is case sensitive', () {
      expect(isPhoneBlockedVerdict('Phone_Is_Blocked'), isFalse);
    });
  });
}
