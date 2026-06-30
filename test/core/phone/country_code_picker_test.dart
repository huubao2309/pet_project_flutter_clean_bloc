import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/phone/country_code_picker.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Future<void> pumpPicker(WidgetTester tester) => tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountryCodePicker(onSelected: (_) {}),
          ),
        ),
      );

  testWidgets('lists countries up front', (tester) async {
    await pumpPicker(tester);

    // The first entries of the bundled list are visible.
    expect(find.text('Afghanistan'), findsOneWidget);
    expect(find.text('+93'), findsOneWidget);
  });

  testWidgets('search filters the list by dial code', (tester) async {
    await pumpPicker(tester);

    // Query by dial code so the typed text can't collide with a country name.
    await tester.enterText(find.byType(TextField), '+355');
    await tester.pumpAndSettle();

    expect(find.text('Albania'), findsOneWidget);
    expect(find.text('Afghanistan'), findsNothing);
  });

  testWidgets('a non-matching query empties the list', (tester) async {
    await pumpPicker(tester);

    await tester.enterText(find.byType(TextField), 'zzzzzz');
    await tester.pumpAndSettle();

    expect(find.text('Afghanistan'), findsNothing);
    expect(find.text('Albania'), findsNothing);
  });
}
