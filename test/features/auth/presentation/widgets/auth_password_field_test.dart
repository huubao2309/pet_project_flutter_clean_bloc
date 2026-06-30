import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_text_field.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/auth_password_field.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('wraps an obscured AppTextField with an eye toggle',
      (tester) async {
    await tester.pumpWidget(
      wrap(const AuthPasswordField(hintText: 'Password')),
    );

    expect(find.byType(AppTextField), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();
    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('renders error text and forwards onTextChanged',
      (tester) async {
    final controller = TextEditingController();
    var changed = '';
    await tester.pumpWidget(
      wrap(AuthPasswordField(
        hintText: 'Password',
        controller: controller,
        errorText: 'Required',
        onTextChanged: (v) => changed = v,
      ),),
    );

    expect(find.text('Required'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'abc');
    expect(changed, 'abc');
    expect(controller.text, 'abc');
  });
}
