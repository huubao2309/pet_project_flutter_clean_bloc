import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/password_strength.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/password_requirement_hint.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/validate_icon_widget.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  const allValid = PasswordStrength(
    hasMinLength: true,
    hasSpecialChar: true,
    hasNumber: true,
    hasCapital: true,
  );

  testWidgets('collapses to a valid confirmation when all rules pass',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const PasswordRequirementHint(
          strength: allValid,
          isPasswordEmpty: false,
        ),
      ),
    );

    expect(find.text('auth.register.password_valid'.tr()), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
  });

  testWidgets('shows a collapsible requirements line when not all valid',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const PasswordRequirementHint(
          strength: PasswordStrength.empty(),
          isPasswordEmpty: true,
        ),
      ),
    );

    expect(
      find.text('auth.register.password_requirements'.tr()),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byIcon(Icons.expand_more), findsOneWidget);
    // Popover is collapsed initially.
    expect(find.byType(ValidateIconWidget), findsNothing);
  });

  testWidgets('expands the popover listing the rule states (empty password)',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const PasswordRequirementHint(
          strength: PasswordStrength.empty(),
          isPasswordEmpty: true,
        ),
      ),
    );

    await tester.tap(find.text('auth.register.password_requirements'.tr()));
    await tester.pump();

    expect(find.byIcon(Icons.expand_less), findsOneWidget);
    expect(find.text('auth.register.password_must'.tr()), findsOneWidget);
    // One row per rule.
    expect(find.byType(ValidateIconWidget), findsNWidgets(4));
  });

  testWidgets('expands the popover with mixed valid/invalid rules',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const PasswordRequirementHint(
          strength: PasswordStrength(
            hasMinLength: true,
            hasSpecialChar: false,
            hasNumber: true,
            hasCapital: false,
          ),
          isPasswordEmpty: false,
        ),
      ),
    );

    await tester.tap(find.text('auth.register.password_requirements'.tr()));
    await tester.pump();

    expect(find.byType(ValidateIconWidget), findsNWidgets(4));
  });
}
