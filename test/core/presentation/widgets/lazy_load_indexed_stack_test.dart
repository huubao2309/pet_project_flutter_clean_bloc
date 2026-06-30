import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/lazy_load_indexed_stack.dart';

void main() {
  Widget stack(int index) => Directionality(
        textDirection: TextDirection.ltr,
        child: LazyLoadIndexedStack(
          index: index,
          unloadWidget: const Text('UNLOADED'),
          children: const [Text('A'), Text('B'), Text('C')],
        ),
      );

  testWidgets('only the active child is built; others are the unload widget',
      (tester) async {
    await tester.pumpWidget(stack(0));

    expect(find.text('A'), findsOneWidget);
    // B and C were never visited → replaced by the unload widget.
    expect(find.text('B', skipOffstage: false), findsNothing);
    expect(find.text('C', skipOffstage: false), findsNothing);
    expect(find.text('UNLOADED', skipOffstage: false), findsNWidgets(2));
  });

  testWidgets('switching to a tab materialises it and keeps prior ones alive',
      (tester) async {
    await tester.pumpWidget(stack(0));
    await tester.pumpWidget(stack(1));

    // B is now built...
    expect(find.text('B'), findsOneWidget);
    // ...A stays alive (offstage) — only one unload widget remains (index 2).
    expect(find.text('A', skipOffstage: false), findsOneWidget);
    expect(find.text('UNLOADED', skipOffstage: false), findsOneWidget);
  });
}
