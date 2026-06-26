import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/app_text_field.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the error caption when errorText is set', (tester) async {
    await tester.pumpWidget(
      wrap(const AppTextField(hintText: 'Email', errorText: 'Required')),
    );

    expect(find.text('Required'), findsOneWidget);
  });

  testWidgets('shows no error caption when errorText is null or empty',
      (tester) async {
    await tester.pumpWidget(
      wrap(const AppTextField(hintText: 'Email', errorText: '')),
    );
    expect(find.text('Required'), findsNothing);

    await tester.pumpWidget(
      wrap(const AppTextField(hintText: 'Email')),
    );
    expect(find.text('Required'), findsNothing);
  });

  testWidgets('obscure field shows the eye and toggles it on tap',
      (tester) async {
    await tester.pumpWidget(
      wrap(const AppTextField(hintText: 'Password', obscure: true)),
    );

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
  });

  testWidgets('non-obscure field shows no eye toggle', (tester) async {
    await tester.pumpWidget(
      wrap(const AppTextField(hintText: 'Email')),
    );

    expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    expect(find.byIcon(Icons.visibility_outlined), findsNothing);
  });
}
