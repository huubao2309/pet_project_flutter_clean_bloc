import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/domain/entities/deal_record.dart';

void main() {
  DealRecord build() => const DealRecord(
        id: 'd1',
        propertyTitle: 'Can ho',
        customerName: 'Le Van C',
        dealValue: 4000000000,
        commission: 120000000,
        dateLabel: '12/06/2026',
        status: DealStatus.completed,
      );

  group('DealStatus', () {
    test('has the three expected values', () {
      expect(DealStatus.values, [
        DealStatus.deposited,
        DealStatus.completed,
        DealStatus.cancelled,
      ]);
    });
  });

  group('DealRecord', () {
    test('stores all fields', () {
      final d = build();
      expect(d.id, 'd1');
      expect(d.propertyTitle, 'Can ho');
      expect(d.customerName, 'Le Van C');
      expect(d.dealValue, 4000000000);
      expect(d.commission, 120000000);
      expect(d.dateLabel, '12/06/2026');
      expect(d.status, DealStatus.completed);
    });

    group('copyWith', () {
      test('overrides only provided fields', () {
        final updated = build().copyWith(status: DealStatus.cancelled);
        expect(updated.status, DealStatus.cancelled);
        expect(updated.id, 'd1');
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
