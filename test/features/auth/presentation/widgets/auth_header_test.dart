import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/auth_header.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders only the title when no caption is given',
      (tester) async {
    await tester.pumpWidget(
      wrap(const AuthHeader(titleKey: 'auth.register.title')),
    );

    expect(find.text('auth.register.title'.tr()), findsOneWidget);
    // Title only => single Text.
    expect(find.byType(Text), findsOneWidget);
  });

  testWidgets('renders the caption with named args when provided',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const AuthHeader(
          titleKey: 'auth.register.password_title',
          captionKey: 'auth.register.password_caption',
          captionArgs: {'phone': '0900000000'},
        ),
      ),
    );

    expect(find.text('auth.register.password_title'.tr()), findsOneWidget);
    expect(
      find.text(
        'auth.register.password_caption'.tr(namedArgs: {'phone': '0900000000'}),
      ),
      findsOneWidget,
    );
    expect(find.byType(Text), findsNWidgets(2));
  });
}
