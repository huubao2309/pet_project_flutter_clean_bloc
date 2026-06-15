// ignore_for_file: prefer_single_quotes, prefer_final_locals, eol_at_end_of_file
// Vendored country utilities ported from the source app — kept verbatim.
part of '../country_phone_validator.dart';

/// [CountryUtils]
/// A utility class providing methods for retrieving country information
/// and validating phone numbers.
class CountryUtils {
  /// Retrieve a country by its dial code.
  static Country? getCountryByDialCode(String dialCode) {
    final index =
    countries.indexWhere((country) => country.dialCode == dialCode);
    if (index < 0) return null;
    return countries[index];
  }

  /// Retrieve a country by its ISO code.

  static Country? getCountryByIsoCode(String isoCode) {
    final index = countries.indexWhere((country) => country.isoCode == isoCode);
    if (index < 0) return null;
    return countries[index];
  }

  /// Validate a phone number based on the country's dial code.
  static bool validatePhoneNumber(String phoneNumber, String dialCode) {
    Country? country = getCountryByDialCode(dialCode);
    if (country == null) return false;
    int length = phoneNumber.length;
    bool lengthValid =
        length >= country.phoneMinLength && length <= country.phoneMaxLength;
    bool startingDigitsValid = country.startingDigits.isEmpty ||
        country.startingDigits.any((digits) => phoneNumber.startsWith(digits));
    return lengthValid && startingDigitsValid;
  }

  /// Validate a phone number based on the country
  static bool validatePhoneNumberByCountry(String phoneNumber, Country country) {
    int length = phoneNumber.length;
    bool lengthValid =
        length >= country.phoneMinLength && length <= country.phoneMaxLength;
    bool startingDigitsValid = country.startingDigits.isEmpty ||
        country.startingDigits.any((digits) => phoneNumber.startsWith(digits));
    return lengthValid && startingDigitsValid;
  }
}