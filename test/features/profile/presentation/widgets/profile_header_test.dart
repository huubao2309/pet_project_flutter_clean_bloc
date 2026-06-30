import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/widgets/profile_header.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the name, masked phone and avatar icons',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProfileHeader(name: 'Bảo Nguyễn', maskedPhone: '••• ••• 1234'),
      ),
    );

    expect(find.text('Bảo Nguyễn'), findsOneWidget);
    expect(find.text('••• ••• 1234'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
  });
}
