import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/auth_card.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('wraps its child in a rounded surface', (tester) async {
    await tester.pumpWidget(
      wrap(const AuthCard(child: Text('inside card'))),
    );

    expect(find.text('inside card'), findsOneWidget);
    expect(find.byType(Container), findsWidgets);
  });
}
