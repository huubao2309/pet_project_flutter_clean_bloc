import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_error_view.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: child);

  testWidgets('renders the title, description and icon', (tester) async {
    await tester.pumpWidget(
      wrap(
        const AppErrorView(
          title: 'Account locked',
          description: 'Too many attempts',
        ),
      ),
    );

    expect(find.text('Account locked'), findsOneWidget);
    expect(find.text('Too many attempts'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
  });

  testWidgets('omits both actions when no labels are given', (tester) async {
    await tester.pumpWidget(
      wrap(const AppErrorView(title: 't', description: 'd')),
    );

    expect(find.text('Retry'), findsNothing);
    expect(find.text('Back'), findsNothing);
  });

  testWidgets('shows the actions and fires their callbacks', (tester) async {
    var primary = 0;
    var secondary = 0;

    await tester.pumpWidget(
      wrap(
        AppErrorView(
          title: 't',
          description: 'd',
          primaryLabel: 'Retry',
          onPrimary: () => primary++,
          secondaryLabel: 'Back',
          onSecondary: () => secondary++,
        ),
      ),
    );

    expect(find.text('Retry'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.tap(find.text('Back'));
    await tester.pump();

    expect(primary, 1);
    expect(secondary, 1);
  });
}
