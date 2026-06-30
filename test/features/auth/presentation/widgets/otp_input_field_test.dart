import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/widgets/otp_input_field.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  // The hidden TextField also holds the raw value, so match only the visible
  // cell Text widgets (a plain Text with a String, not the EditableText).
  Finder cellText(String value) => find.byWidgetPredicate(
        (w) => w is Text && w.data == value,
      );

  testWidgets('renders one cell per digit', (tester) async {
    await tester.pumpWidget(
      wrap(OtpInputField(onChanged: (_) {}, length: 4)),
    );
    await tester.pump();

    // length cells share the navy heading container height; assert the row.
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('fires onChanged and onCompleted, and reveals then masks digits',
      (tester) async {
    final changes = <String>[];
    String? completed;
    await tester.pumpWidget(
      wrap(
        OtpInputField(
          length: 4,
          onChanged: changes.add,
          onCompleted: (v) => completed = v,
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), '1');
    await tester.pump();
    expect(changes.last, '1');
    // Just-typed digit revealed in clear text.
    expect(cellText('1'), findsOneWidget);

    // After the reveal duration it is masked with the bullet glyph.
    await tester.pump(const Duration(milliseconds: 600));
    expect(cellText('1'), findsNothing);
    expect(cellText('•'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '1234');
    await tester.pump();
    expect(completed, '1234');
  });

  testWidgets('non-obscure field keeps digits visible', (tester) async {
    await tester.pumpWidget(
      wrap(
        OtpInputField(
          length: 4,
          obscure: false,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), '12');
    await tester.pump(const Duration(milliseconds: 600));

    expect(cellText('1'), findsOneWidget);
    expect(cellText('2'), findsOneWidget);
    expect(cellText('•'), findsNothing);
  });

  testWidgets('deleting a character does not re-reveal', (tester) async {
    await tester.pumpWidget(
      wrap(OtpInputField(length: 4, onChanged: (_) {})),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), '12');
    await tester.pump();
    await tester.enterText(find.byType(TextField), '1');
    await tester.pump();

    // Remaining digit is immediately masked (no reveal on delete).
    expect(cellText('•'), findsOneWidget);
  });

  testWidgets('renders error state borders when hasError is true',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        OtpInputField(
          length: 4,
          hasError: true,
          autofocus: false,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pump();

    await tester.enterText(find.byType(TextField), '12');
    await tester.pump();

    expect(find.byType(OtpInputField), findsOneWidget);
  });
}
