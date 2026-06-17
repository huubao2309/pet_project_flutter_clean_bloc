/// Pure, framework-free input validators shared across features.
abstract final class Validators {
  static final _email = RegExp(
    r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final _specialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  static final _capital = RegExp(r'[A-Z]');
  static final _number = RegExp(r'\d');

  /// A valid phone number: exactly 10 digits starting with 0.
  static final _phone = RegExp(r'^0\d{9}$');

  static bool isEmailValid(String value) => _email.hasMatch(value);

  static bool isPhoneValid(String value) => _phone.hasMatch(value);

  static bool hasMinLength(String value, [int min = 8]) => value.length >= min;
  static bool hasSpecialChar(String value) => _specialChar.hasMatch(value);
  static bool hasCapital(String value) => _capital.hasMatch(value);
  static bool hasNumber(String value) => _number.hasMatch(value);
}
