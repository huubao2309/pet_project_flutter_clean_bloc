import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_filter.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_listing.dart';

void main() {
  group('CommissionSort', () {
    test('has the four expected values', () {
      expect(CommissionSort.values, [
        CommissionSort.score,
        CommissionSort.priceDesc,
        CommissionSort.priceAsc,
        CommissionSort.nearest,
      ]);
    });
  });

  group('CommissionFilter', () {
    test('defaults to score sort and empty statuses', () {
      const filter = CommissionFilter();
      expect(filter.sort, CommissionSort.score);
      expect(filter.statuses, isEmpty);
      expect(filter.hasStatusFilter, isFalse);
    });

    test('hasStatusFilter is true when statuses non-empty', () {
      const filter = CommissionFilter(statuses: {CommissionStatus.available});
      expect(filter.hasStatusFilter, isTrue);
    });

    group('copyWith', () {
      test('overrides only provided fields', () {
        final updated =
            const CommissionFilter().copyWith(sort: CommissionSort.nearest);
        expect(updated.sort, CommissionSort.nearest);
        expect(updated.statuses, isEmpty);
      });

      test('returns equal instance with no args', () {
        const filter = CommissionFilter(sort: CommissionSort.priceAsc);
        expect(filter.copyWith(), equals(filter));
      });
    });

    group('toggleStatus', () {
      test('adds a status not present', () {
        final result =
            const CommissionFilter().toggleStatus(CommissionStatus.deposited);
        expect(result.statuses, {CommissionStatus.deposited});
      });

      test('removes a status already present', () {
        const filter = CommissionFilter(statuses: {CommissionStatus.deposited});
        final result = filter.toggleStatus(CommissionStatus.deposited);
        expect(result.statuses, isEmpty);
      });

      test('does not mutate the original set', () {
        const filter = CommissionFilter(statuses: {CommissionStatus.available});
        filter.toggleStatus(CommissionStatus.deposited);
        expect(filter.statuses, {CommissionStatus.available});
      });

      test('preserves the existing sort', () {
        const filter = CommissionFilter(sort: CommissionSort.priceDesc);
        final result = filter.toggleStatus(CommissionStatus.urgentSell);
        expect(result.sort, CommissionSort.priceDesc);
      });
    });

    test('is Equatable by props', () {
      expect(const CommissionFilter(), equals(const CommissionFilter()));
      expect(
        const CommissionFilter(sort: CommissionSort.nearest),
        isNot(equals(const CommissionFilter())),
      );
    });
  });
}
