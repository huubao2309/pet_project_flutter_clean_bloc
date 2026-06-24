import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/phone/country_phone_validator.dart';

void main() {
  group('Country model', () {
    test('stores its constructor arguments', () {
      final country = Country('Wonderland', 'WL', '+999', 8, 10,
          startingDigits: const ['7', '8'],);
      expect(country.name, 'Wonderland');
      expect(country.isoCode, 'WL');
      expect(country.dialCode, '+999');
      expect(country.phoneMinLength, 8);
      expect(country.phoneMaxLength, 10);
      expect(country.startingDigits, ['7', '8']);
    });

    test('defaults startingDigits to an empty list', () {
      final country = Country('Nowhere', 'NW', '+000', 5, 5);
      expect(country.startingDigits, isEmpty);
    });
  });

  group('CountryUtils.getCountryByDialCode', () {
    test('returns the matching country', () {
      final country = CountryUtils.getCountryByDialCode('+84');
      expect(country, isNotNull);
      expect(country!.isoCode, 'VN');
      expect(country.name, 'Vietnam');
    });

    test('returns null for an unknown dial code', () {
      expect(CountryUtils.getCountryByDialCode('+0000'), isNull);
    });
  });

  group('CountryUtils.getCountryByIsoCode', () {
    test('returns the matching country', () {
      final country = CountryUtils.getCountryByIsoCode('VN');
      expect(country, isNotNull);
      expect(country!.dialCode, '+84');
    });

    test('returns null for an unknown ISO code', () {
      expect(CountryUtils.getCountryByIsoCode('ZZ'), isNull);
    });
  });

  group('CountryUtils.validatePhoneNumber', () {
    test('accepts a phone of valid length for the dial code', () {
      // Vietnam: min/max length 9, no starting-digit restriction.
      expect(CountryUtils.validatePhoneNumber('123456789', '+84'), isTrue);
    });

    test('rejects a phone that is too short or too long', () {
      expect(CountryUtils.validatePhoneNumber('12345678', '+84'), isFalse);
      expect(CountryUtils.validatePhoneNumber('1234567890', '+84'), isFalse);
    });

    test('returns false for an unknown dial code', () {
      expect(CountryUtils.validatePhoneNumber('123456789', '+0000'), isFalse);
    });

    test('enforces startingDigits when present (Egypt +20)', () {
      // Egypt: length 10, must start with "1".
      expect(CountryUtils.validatePhoneNumber('1234567890', '+20'), isTrue);
      expect(CountryUtils.validatePhoneNumber('2234567890', '+20'), isFalse);
    });
  });

  group('CountryUtils.validatePhoneNumberByCountry', () {
    final egypt = CountryUtils.getCountryByDialCode('+20')!;

    test('validates length and starting digits against a country', () {
      expect(
          CountryUtils.validatePhoneNumberByCountry('1234567890', egypt), isTrue,);
      expect(CountryUtils.validatePhoneNumberByCountry('2234567890', egypt),
          isFalse,);
    });

    test('accepts any starting digit when startingDigits is empty', () {
      final vietnam = CountryUtils.getCountryByDialCode('+84')!;
      expect(CountryUtils.validatePhoneNumberByCountry('987654321', vietnam),
          isTrue,);
    });
  });
}
