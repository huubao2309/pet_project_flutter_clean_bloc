import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/widgets/app_overlay_icon.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Future<void> pumpIcon(WidgetTester tester, AppOverlayIconType type) =>
      tester.pumpWidget(
        MaterialApp(home: Scaffold(body: AppOverlayIcon(type: type))),
      );

  testWidgets('each preset maps to the right glyph', (tester) async {
    await pumpIcon(tester, AppOverlayIconType.confirm);
    expect(find.byIcon(Icons.question_mark_rounded), findsOneWidget);

    await pumpIcon(tester, AppOverlayIconType.warning);
    expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);

    await pumpIcon(tester, AppOverlayIconType.success);
    expect(find.byIcon(Icons.check_rounded), findsOneWidget);

    await pumpIcon(tester, AppOverlayIconType.info);
    expect(find.byIcon(Icons.info_outline_rounded), findsOneWidget);
  });
}
