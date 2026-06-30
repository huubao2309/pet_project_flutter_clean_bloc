import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_sheet_option.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget hostFor(AppSheetOption option, {VoidCallback? onTapOverride}) =>
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) =>
                option.build(context, onTapOverride: onTapOverride),
          ),
        ),
      );

  test('defaults: not destructive, no selection', () {
    const option = AppSheetOption(label: 'Settings');
    expect(option.isDestructive, isFalse);
    expect(option.selected, isNull);
  });

  testWidgets('renders its label', (tester) async {
    await tester.pumpWidget(hostFor(const AppSheetOption(label: 'Logout')));
    expect(find.text('Logout'), findsOneWidget);
  });

  testWidgets('tap runs both onTapOverride and onTap', (tester) async {
    var tapped = 0;
    var override = 0;
    await tester.pumpWidget(
      hostFor(
        AppSheetOption(label: 'Pick', onTap: () => tapped++),
        onTapOverride: () => override++,
      ),
    );

    await tester.tap(find.text('Pick'));
    await tester.pump();

    expect(tapped, 1);
    expect(override, 1);
  });

  testWidgets('renders a leading icon when given', (tester) async {
    await tester.pumpWidget(
      hostFor(const AppSheetOption(label: 'Edit', leadingIcon: Icons.edit)),
    );
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}
