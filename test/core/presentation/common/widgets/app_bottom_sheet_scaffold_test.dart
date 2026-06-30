import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_overlay_action.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/widgets/app_bottom_sheet_scaffold.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('renders title and a close button by default', (tester) async {
    await pump(tester, const AppBottomSheetScaffold(title: 'Options'));

    expect(find.text('Options'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });

  testWidgets('hides the close button when showClose is false', (tester) async {
    await pump(
      tester,
      const AppBottomSheetScaffold(title: 'Options', showClose: false),
    );

    expect(find.byIcon(Icons.close_rounded), findsNothing);
  });

  testWidgets('renders body items and footer actions', (tester) async {
    await pump(
      tester,
      const AppBottomSheetScaffold(
        title: 'Pick',
        items: [Text('row-1'), Text('row-2')],
        actions: [AppOverlayAction(label: 'Confirm')],
      ),
    );

    expect(find.text('row-1'), findsOneWidget);
    expect(find.text('row-2'), findsOneWidget);
    expect(find.text('Confirm'), findsOneWidget);
  });
}
