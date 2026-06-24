import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/view_model/main_view_model.dart';

void main() {
  test('starts on the first tab (index 0)', () {
    final vm = MainViewModel();
    expect(vm.currentState, 0);
    expect(vm.tabs.length, 5);
    vm.close();
  });

  test('changeTab emits the new index', () async {
    final vm = MainViewModel();
    final states = <int>[];
    final sub = vm.stream.listen(states.add);

    vm.changeTab(3);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, [3]);
    expect(vm.currentState, 3);
    await vm.close();
  });

  test('changeTab ignores out-of-range indices', () async {
    final vm = MainViewModel();
    final states = <int>[];
    final sub = vm.stream.listen(states.add);

    vm.changeTab(-1);
    vm.changeTab(5);
    vm.changeTab(99);
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();

    expect(states, isEmpty);
    expect(vm.currentState, 0);
    await vm.close();
  });
}
