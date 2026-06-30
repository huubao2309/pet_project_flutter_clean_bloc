import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/presentation/widgets/profile_tile.dart';

import '../../../../helpers/localization_test_harness.dart';

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets('renders the title and shows a chevron when tappable',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        ProfileTile(
          icon: Icons.lock_outline,
          title: 'Change password',
          onTap: () {},
        ),
      ),
    );

    expect(find.text('Change password'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);
  });

  testWidgets('invokes onTap when tapped', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      wrap(
        ProfileTile(
          icon: Icons.lock_outline,
          title: 'Tap me',
          onTap: () => taps++,
        ),
      ),
    );

    await tester.tap(find.byType(ProfileTile));
    expect(taps, 1);
  });

  testWidgets('renders the value and hides the chevron when showChevron false',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ProfileTile(
          icon: Icons.info_outline,
          title: 'Version',
          value: '1.0.0',
          showChevron: false,
        ),
      ),
    );

    expect(find.text('Version'), findsOneWidget);
    expect(find.text('1.0.0'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('renders a custom trailing widget instead of the chevron',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        ProfileTile(
          icon: Icons.dark_mode_outlined,
          title: 'Dark mode',
          onTap: () {},
          trailing: const Icon(Icons.toggle_on),
        ),
      ),
    );

    expect(find.byIcon(Icons.toggle_on), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('uses destructive styling for the destructive variant',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        ProfileTile(
          icon: Icons.delete_outline,
          title: 'Delete',
          destructive: true,
          onTap: () {},
        ),
      ),
    );

    expect(find.text('Delete'), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);
  });
}
