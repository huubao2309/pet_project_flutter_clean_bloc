import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/domain/entities/property_listing.dart';

void main() {
  PropertyListing build() => const PropertyListing(
        id: 'p1',
        title: 'Can ho 2PN',
        address: 'Q7',
        price: 3500000000,
        area: 68,
        bedrooms: 2,
        type: 'Can ho',
        status: PropertyStatus.available,
      );

  group('PropertyStatus', () {
    test('has the three expected values', () {
      expect(PropertyStatus.values, [
        PropertyStatus.available,
        PropertyStatus.deposited,
        PropertyStatus.sold,
      ]);
    });
  });

  group('PropertyListing', () {
    test('stores all fields', () {
      final p = build();
      expect(p.id, 'p1');
      expect(p.title, 'Can ho 2PN');
      expect(p.address, 'Q7');
      expect(p.price, 3500000000);
      expect(p.area, 68);
      expect(p.bedrooms, 2);
      expect(p.type, 'Can ho');
      expect(p.status, PropertyStatus.available);
    });

    group('copyWith', () {
      test('overrides only provided fields', () {
        final updated = build().copyWith(status: PropertyStatus.sold, area: 70);
        expect(updated.status, PropertyStatus.sold);
        expect(updated.area, 70);
        expect(updated.id, 'p1');
      });

      test('returns equal instance with no args', () {
        expect(build().copyWith(), equals(build()));
      });
    });

    test('is Equatable by props', () {
      expect(build(), equals(build()));
      expect(build(), isNot(equals(build().copyWith(id: 'x'))));
    });
  });
}
