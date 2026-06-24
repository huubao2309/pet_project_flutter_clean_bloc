import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/qr_scan/data/scanned_property_resolver.dart';
import 'package:pet_project_flutter_clean_bloc/features/qr_scan/domain/entities/scanned_property.dart';

void main() {
  group('ScannedPropertyResolver.resolve', () {
    test('echoes the raw code back on the resolved property', () {
      final property = ScannedPropertyResolver.resolve('QR-PAYLOAD-1');
      expect(property.code, 'QR-PAYLOAD-1');
    });

    test('returns the fixed demo listing fields', () {
      final property = ScannedPropertyResolver.resolve('any');

      expect(property, isA<ScannedProperty>());
      expect(property.title, 'Vinhomes Central Park');
      expect(property.address, 'Bình Thạnh, TP. HCM');
      expect(property.area, 78);
      expect(property.bedrooms, 2);
      expect(property.price, 5600000000);
      expect(property.commissionAmount, 168000000);
    });

    test('handles an empty code', () {
      final property = ScannedPropertyResolver.resolve('');
      expect(property.code, '');
      expect(property.title, 'Vinhomes Central Park');
    });

    test('only the code varies between two different payloads', () {
      final a = ScannedPropertyResolver.resolve('code-a');
      final b = ScannedPropertyResolver.resolve('code-b');

      expect(a.code, 'code-a');
      expect(b.code, 'code-b');
      // Everything else is identical (mocked resolver).
      expect(a.title, b.title);
      expect(a.price, b.price);
      expect(a.commissionAmount, b.commissionAmount);
      expect(a, isNot(equals(b)));
    });
  });
}
