import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/widgets/profile_group.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/widgets/profile_tile.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders all children with dividers between them',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProfileGroup(
          children: [
            ProfileTile(icon: Icons.lock_outline, title: 'A'),
            ProfileTile(icon: Icons.language_outlined, title: 'B'),
            ProfileTile(icon: Icons.info_outline, title: 'C'),
          ],
        ),
      ),
    );

    expect(find.text('A'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
    expect(find.text('C'), findsOneWidget);
    // Three rows → two separating dividers.
    expect(find.byType(Divider), findsNWidgets(2));
  });

  testWidgets('renders a single child without dividers', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProfileGroup(
          children: [ProfileTile(icon: Icons.logout, title: 'Only')],
        ),
      ),
    );

    expect(find.text('Only'), findsOneWidget);
    expect(find.byType(Divider), findsNothing);
  });
}
