import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_builder.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_consumer.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_context_x.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_listener.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/view_model_provider.dart';

class _CounterViewModel extends ViewModel<int> {
  _CounterViewModel() : super(0);
  void increment() => setState(currentState + 1);
}

class _LabelViewModel extends ViewModel<String> {
  _LabelViewModel() : super('hello');
}

Widget _ltr(Widget child) =>
    Directionality(textDirection: TextDirection.ltr, child: child);

void main() {
  group('ViewModel base', () {
    test('currentState mirrors state and setState publishes new states',
        () async {
      final vm = _CounterViewModel();
      expect(vm.currentState, 0);

      final states = <int>[];
      final sub = vm.stream.listen(states.add);
      vm.increment();
      vm.increment();
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(states, [1, 2]);
      expect(vm.currentState, 2);
      await vm.close();
    });
  });

  testWidgets('Provider + Builder render state and rebuild on setState',
      (tester) async {
    late _CounterViewModel vm;
    await tester.pumpWidget(
      _ltr(
        ViewModelProvider<_CounterViewModel>(
          create: (_) => vm = _CounterViewModel(),
          child: ViewModelBuilder<_CounterViewModel, int>(
            builder: (context, state) => Text('count=$state'),
          ),
        ),
      ),
    );

    expect(find.text('count=0'), findsOneWidget);
    vm.increment();
    await tester.pumpAndSettle();
    expect(find.text('count=1'), findsOneWidget);
  });

  testWidgets('context.viewModel reads the VM to invoke methods',
      (tester) async {
    await tester.pumpWidget(
      _ltr(
        ViewModelProvider<_CounterViewModel>(
          create: (_) => _CounterViewModel(),
          child: ViewModelBuilder<_CounterViewModel, int>(
            builder: (context, state) => GestureDetector(
              onTap: () => context.viewModel<_CounterViewModel>().increment(),
              child: Text('v=$state'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('v=0'));
    await tester.pump();
    expect(find.text('v=1'), findsOneWidget);
  });

  testWidgets('watchViewModel subscribes the widget to rebuilds',
      (tester) async {
    late _CounterViewModel vm;
    await tester.pumpWidget(
      _ltr(
        ViewModelProvider<_CounterViewModel>(
          create: (_) => vm = _CounterViewModel(),
          child: Builder(
            builder: (context) {
              final m = context.watchViewModel<_CounterViewModel>();
              return Text('w=${m.currentState}');
            },
          ),
        ),
      ),
    );

    expect(find.text('w=0'), findsOneWidget);
    vm.increment();
    await tester.pumpAndSettle();
    expect(find.text('w=1'), findsOneWidget);
  });

  testWidgets('Listener runs side effects without rebuilding its child',
      (tester) async {
    late _CounterViewModel vm;
    final seen = <int>[];
    await tester.pumpWidget(
      _ltr(
        ViewModelProvider<_CounterViewModel>(
          create: (_) => vm = _CounterViewModel(),
          child: ViewModelListener<_CounterViewModel, int>(
            listener: (_, state) => seen.add(state),
            child: const Text('static'),
          ),
        ),
      ),
    );

    vm.increment();
    vm.increment();
    await tester.pump();

    expect(seen, [1, 2]);
    expect(find.text('static'), findsOneWidget);
  });

  testWidgets('Consumer both builds and listens', (tester) async {
    late _CounterViewModel vm;
    final seen = <int>[];
    await tester.pumpWidget(
      _ltr(
        ViewModelProvider<_CounterViewModel>(
          create: (_) => vm = _CounterViewModel(),
          child: ViewModelConsumer<_CounterViewModel, int>(
            listener: (_, state) => seen.add(state),
            builder: (_, state) => Text('c=$state'),
          ),
        ),
      ),
    );

    expect(find.text('c=0'), findsOneWidget);
    vm.increment();
    await tester.pumpAndSettle();
    expect(find.text('c=1'), findsOneWidget);
    expect(seen, [1]);
  });

  testWidgets('MultiViewModelProvider builds its subtree with all providers',
      (tester) async {
    await tester.pumpWidget(
      _ltr(
        MultiViewModelProvider(
          providers: [
            ViewModelProvider<_CounterViewModel>(
              create: (_) => _CounterViewModel(),
              child: const SizedBox(),
            ),
            ViewModelProvider<_LabelViewModel>(
              create: (_) => _LabelViewModel(),
              child: const SizedBox(),
            ),
          ],
          child: const Text('subtree'),
        ),
      ),
    );

    expect(find.text('subtree'), findsOneWidget);
  });
}
