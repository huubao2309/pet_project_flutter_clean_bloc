import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_listing.dart';

void main() {
  CommissionListing build({int? expiresInDays = 10}) => CommissionListing(
        id: 'c1',
        title: 'Nha pho',
        address: 'Q1',
        distanceKm: 2.5,
        price: 5000000000,
        commissionRate: 0.03,
        commissionAmount: 150000000,
        commissionScore: 8.5,
        type: 'Nha pho',
        status: CommissionStatus.available,
        expiresInDays: expiresInDays,
      );

  group('CommissionStatus', () {
    test('has the three expected values', () {
      expect(CommissionStatus.values, [
        CommissionStatus.urgentSell,
        CommissionStatus.available,
        CommissionStatus.deposited,
      ]);
    });
  });

  group('CommissionListing', () {
    test('stores all fields', () {
      final c = build();
      expect(c.id, 'c1');
      expect(c.title, 'Nha pho');
      expect(c.address, 'Q1');
      expect(c.distanceKm, 2.5);
      expect(c.price, 5000000000);
      expect(c.commissionRate, 0.03);
      expect(c.commissionAmount, 150000000);
      expect(c.commissionScore, 8.5);
      expect(c.type, 'Nha pho');
      expect(c.status, CommissionStatus.available);
      expect(c.expiresInDays, 10);
    });

    test('expiresInDays is optional', () {
      expect(build(expiresInDays: null).expiresInDays, isNull);
    });

    group('isExpiringSoon', () {
      test('false when expiresInDays is null', () {
        expect(build(expiresInDays: null).isExpiringSoon, isFalse);
      });

      test('true when <= 3 days', () {
        expect(build(expiresInDays: 3).isExpiringSoon, isTrue);
        expect(build(expiresInDays: 0).isExpiringSoon, isTrue);
      });

      test('false when > 3 days', () {
        expect(build(expiresInDays: 4).isExpiringSoon, isFalse);
      });
    });

    group('copyWith', () {
      test('overrides only provided fields', () {
        final updated = build().copyWith(
          status: CommissionStatus.deposited,
          commissionScore: 9.9,
        );
        expect(updated.status, CommissionStatus.deposited);
        expect(updated.commissionScore, 9.9);
        expect(updated.id, 'c1');
        expect(updated.price, 5000000000);
      });

      test('returns an equal instance when no args given', () {
        expect(build().copyWith(), equals(build()));
      });
    });

    test('is Equatable by props', () {
      expect(build(), equals(build()));
      expect(build(), isNot(equals(build().copyWith(id: 'other'))));
    });
  });
}
