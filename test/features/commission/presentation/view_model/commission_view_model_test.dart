import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_filter.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/domain/entities/commission_listing.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/view_model/commission_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/commission/presentation/view_model/commission_view_model.dart';

void main() {
  test('starts in CommissionInitial', () {
    final vm = CommissionViewModel();
    expect(vm.currentState, isA<CommissionInitial>());
    vm.close();
  });

  test('initialize emits Locating then Loaded with default score sort',
      () async {
    final vm = CommissionViewModel();
    final states = <CommissionState>[];
    final sub = vm.stream.listen(states.add);

    await vm.initialize();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [isA<CommissionLocating>(), isA<CommissionLoaded>()]);
    final loaded = vm.currentState as CommissionLoaded;
    expect(loaded.locationLabel, 'Quận 1');
    expect(loaded.radiusKm, 5);
    expect(loaded.totalCount, 5);
    expect(loaded.listings, hasLength(5));
    // Default sort is by score descending.
    final scores = loaded.listings.map((l) => l.commissionScore).toList();
    final sorted = [...scores]..sort((a, b) => b.compareTo(a));
    expect(scores, sorted);
    await vm.close();
  });

  test('applyFilter with status filter narrows and re-sorts the visible list',
      () async {
    final vm = CommissionViewModel();
    await vm.initialize();

    final states = <CommissionState>[];
    final sub = vm.stream.listen(states.add);
    vm.applyFilter(
      const CommissionFilter(
        sort: CommissionSort.priceAsc,
        statuses: {CommissionStatus.urgentSell},
      ),
    );
    await sub.cancel();

    final loaded = vm.currentState as CommissionLoaded;
    expect(
      loaded.listings.every((l) => l.status == CommissionStatus.urgentSell),
      isTrue,
    );
    expect(loaded.totalCount, 5); // unchanged: counts pre-filter source
    final prices = loaded.listings.map((l) => l.price).toList();
    final sorted = [...prices]..sort();
    expect(prices, sorted);
    await vm.close();
  });

  test('applyFilter before load does not emit (no Loaded state)', () async {
    final vm = CommissionViewModel();
    final states = <CommissionState>[];
    final sub = vm.stream.listen(states.add);

    vm.applyFilter(const CommissionFilter(sort: CommissionSort.nearest));
    await sub.cancel();

    expect(states, isEmpty);
    expect(vm.currentState, isA<CommissionInitial>());
    await vm.close();
  });

  test('nearest sort orders by ascending distance', () async {
    final vm = CommissionViewModel();
    await vm.initialize();
    vm.applyFilter(const CommissionFilter(sort: CommissionSort.nearest));

    final loaded = vm.currentState as CommissionLoaded;
    final distances = loaded.listings.map((l) => l.distanceKm).toList();
    final sorted = [...distances]..sort();
    expect(distances, sorted);
    await vm.close();
  });
}
