import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_overlay_action.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/widgets/app_overlay_actions.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Future<void> pumpActions(
    WidgetTester tester,
    List<AppOverlayAction> actions,
  ) =>
      tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AppOverlayActions(actions: actions))),
      );

  testWidgets('renders nothing for an empty list', (tester) async {
    await pumpActions(tester, const []);
    expect(find.byType(Row), findsNothing);
    expect(find.byType(Column), findsNothing);
  });

  testWidgets('a single action is a full-width button', (tester) async {
    await pumpActions(tester, const [AppOverlayAction(label: 'OK')]);
    expect(find.text('OK'), findsOneWidget);
    expect(find.byType(Row), findsNothing);
  });

  testWidgets('two actions sit side by side in a Row', (tester) async {
    await pumpActions(tester, const [
      AppOverlayAction.secondary(label: 'Huỷ'),
      AppOverlayAction(label: 'Đồng ý'),
    ]);

    expect(find.text('Huỷ'), findsOneWidget);
    expect(find.text('Đồng ý'), findsOneWidget);
    expect(find.byType(Row), findsWidgets);
  });

  testWidgets('three or more actions stack in a Column', (tester) async {
    await pumpActions(tester, const [
      AppOverlayAction(label: 'One'),
      AppOverlayAction(label: 'Two'),
      AppOverlayAction(label: 'Three'),
    ]);

    expect(find.text('One'), findsOneWidget);
    expect(find.text('Two'), findsOneWidget);
    expect(find.text('Three'), findsOneWidget);
    expect(find.byType(Column), findsWidgets);
  });
}
