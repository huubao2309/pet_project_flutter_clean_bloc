import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/currency_format.dart';

void main() {
  group('CurrencyFormat.compactVnd', () {
    test('formats billions with "tỷ" and comma decimal', () {
      expect(CurrencyFormat.compactVnd(1200000000), '1,2 tỷ');
    });

    test('drops trailing ,0 for whole billions', () {
      expect(CurrencyFormat.compactVnd(2000000000), '2 tỷ');
    });

    test('formats millions with "tr"', () {
      expect(CurrencyFormat.compactVnd(12500000), '12,5 tr');
    });

    test('drops trailing ,0 for whole millions', () {
      expect(CurrencyFormat.compactVnd(950000000 ~/ 1), '950 tr');
    });

    test('formats thousands with "k"', () {
      expect(CurrencyFormat.compactVnd(12500), '12,5 k');
    });

    test('returns plain integer string below 1000', () {
      expect(CurrencyFormat.compactVnd(999), '999');
      expect(CurrencyFormat.compactVnd(0), '0');
      expect(CurrencyFormat.compactVnd(500.7), '501');
    });

    test('uses billions branch at the 1e9 boundary', () {
      expect(CurrencyFormat.compactVnd(1000000000), '1 tỷ');
    });

    test('uses millions branch at the 1e6 boundary', () {
      expect(CurrencyFormat.compactVnd(1000000), '1 tr');
    });
  });

  group('CurrencyFormat.fullVnd', () {
    test('groups thousands with dots and appends ₫', () {
      expect(CurrencyFormat.fullVnd(12500000), '12.500.000 ₫');
    });

    test('handles values under 1000 without separators', () {
      expect(CurrencyFormat.fullVnd(500), '500 ₫');
    });

    test('rounds fractional amounts before grouping', () {
      expect(CurrencyFormat.fullVnd(1234.6), '1.235 ₫');
    });

    test('formats exact thousand', () {
      expect(CurrencyFormat.fullVnd(1000), '1.000 ₫');
    });
  });
}
