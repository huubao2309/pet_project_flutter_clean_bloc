import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/validate_icon_widget.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('covers every state and renders an icon', (tester) async {
    for (final state in ValidIconState.values) {
      await tester.pumpWidget(
        wrap(ValidateIconWidget(state: state, title: 'rule')),
      );
      expect(find.byType(SvgPicture), findsOneWidget);
      expect(find.text('rule'), findsOneWidget);
    }
  });

  testWidgets('omits the label when title is null', (tester) async {
    await tester.pumpWidget(
      wrap(ValidateIconWidget(state: ValidIconState.valid)),
    );

    expect(find.byType(SvgPicture), findsOneWidget);
    expect(find.byType(Text), findsNothing);
  });

  testWidgets('honors custom sizeIcon, spacing and textStyle', (tester) async {
    await tester.pumpWidget(
      wrap(
        ValidateIconWidget(
          state: ValidIconState.invalid,
          title: 'custom',
          sizeIcon: 32,
          spacing: 12,
          textStyle: const TextStyle(fontSize: 20),
        ),
      ),
    );

    expect(find.text('custom'), findsOneWidget);
  });
}
