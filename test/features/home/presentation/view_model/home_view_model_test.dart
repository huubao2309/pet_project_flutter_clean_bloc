import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/view_model/home_state.dart';
import 'package:pet_project_flutter_clean_bloc/features/home/presentation/view_model/home_view_model.dart';

void main() {
  test('starts in HomeInitial', () {
    final vm = HomeViewModel();
    expect(vm.currentState, isA<HomeInitial>());
    vm.close();
  });

  test('initialize emits Loading then Loaded with mock data', () async {
    final vm = HomeViewModel();
    final states = <HomeState>[];
    final sub = vm.stream.listen(states.add);

    await vm.initialize();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [isA<HomeLoading>(), isA<HomeLoaded>()]);
    final loaded = vm.currentState as HomeLoaded;
    expect(loaded.agentName, isNotEmpty);
    expect(loaded.listings, hasLength(3));
    expect(loaded.recentDeals, hasLength(3));
    expect(loaded.dealsClosed, 4);
    await vm.close();
  });

  test('refresh reloads through Loading to Loaded', () async {
    final vm = HomeViewModel();
    await vm.initialize();

    final states = <HomeState>[];
    final sub = vm.stream.listen(states.add);
    await vm.refresh();
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [isA<HomeLoading>(), isA<HomeLoaded>()]);
    await vm.close();
  });
}
