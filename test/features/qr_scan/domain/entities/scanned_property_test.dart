import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/qr_scan/domain/entities/scanned_property.dart';

void main() {
  ScannedProperty build() => const ScannedProperty(
        code: 'QR-1',
        title: 'Apartment',
        address: '1 Main St',
        area: 75.5,
        bedrooms: 2,
        price: 3000000000,
        commissionAmount: 90000000,
      );

  group('ScannedProperty', () {
    test('stores all fields', () {
      final p = build();
      expect(p.code, 'QR-1');
      expect(p.title, 'Apartment');
      expect(p.address, '1 Main St');
      expect(p.area, 75.5);
      expect(p.bedrooms, 2);
      expect(p.price, 3000000000);
      expect(p.commissionAmount, 90000000);
    });

    test('is Equatable by all props', () {
      expect(build(), equals(build()));
      expect(build().hashCode, build().hashCode);
    });

    test('differs when a field differs', () {
      const other = ScannedProperty(
        code: 'QR-2',
        title: 'Apartment',
        address: '1 Main St',
        area: 75.5,
        bedrooms: 2,
        price: 3000000000,
        commissionAmount: 90000000,
      );
      expect(build(), isNot(equals(other)));
    });

    test('props lists every field', () {
      expect(
        build().props,
        ['QR-1', 'Apartment', '1 Main St', 75.5, 2, 3000000000.0, 90000000.0],
      );
    });
  });
}
