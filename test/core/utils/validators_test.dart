import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/validators.dart';

void main() {
  group('Validators.isEmailValid', () {
    test('accepts well-formed addresses', () {
      expect(Validators.isEmailValid('user@example.com'), isTrue);
      expect(Validators.isEmailValid('a.b@sub.domain.co'), isTrue);
    });

    test('rejects malformed addresses', () {
      expect(Validators.isEmailValid('no-at-sign'), isFalse);
      expect(Validators.isEmailValid(''), isFalse);
      expect(Validators.isEmailValid('@example.com'), isFalse);
      expect(Validators.isEmailValid('user@'), isFalse);
    });
  });

  group('Validators.isPhoneValid', () {
    test('accepts exactly 10 digits starting with 0', () {
      expect(Validators.isPhoneValid('0123456789'), isTrue);
    });

    test('rejects wrong length or leading digit', () {
      expect(Validators.isPhoneValid('123456789'), isFalse);
      expect(Validators.isPhoneValid('01234567890'), isFalse);
      expect(Validators.isPhoneValid('0123'), isFalse);
      expect(Validators.isPhoneValid('a123456789'), isFalse);
    });
  });

  group('Validators password rules', () {
    test('hasMinLength honours default and custom minimum', () {
      expect(Validators.hasMinLength('1234567'), isFalse);
      expect(Validators.hasMinLength('12345678'), isTrue);
      expect(Validators.hasMinLength('123', 3), isTrue);
    });

    test('hasSpecialChar detects symbols', () {
      expect(Validators.hasSpecialChar('abc!'), isTrue);
      expect(Validators.hasSpecialChar('abc'), isFalse);
    });

    test('hasCapital detects uppercase letters', () {
      expect(Validators.hasCapital('aBc'), isTrue);
      expect(Validators.hasCapital('abc'), isFalse);
    });

    test('hasNumber detects digits', () {
      expect(Validators.hasNumber('abc1'), isTrue);
      expect(Validators.hasNumber('abc'), isFalse);
    });
  });
}
