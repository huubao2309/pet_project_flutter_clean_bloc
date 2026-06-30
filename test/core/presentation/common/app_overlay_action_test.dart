import 'package:benny_style/buttons/base_button_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_overlay_action.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  group('variants', () {
    test('default is a filled brand primary that dismisses on tap', () {
      const action = AppOverlayAction(label: 'OK');
      expect(action.isPrimary, isTrue);
      expect(action.type, BaseButtonType.brand);
      expect(action.dismissOnTap, isTrue);
    });

    test('secondary is an outlined neutral action', () {
      const action = AppOverlayAction.secondary(label: 'Huỷ');
      expect(action.isPrimary, isFalse);
      expect(action.type, BaseButtonType.neutral);
    });

    test('destructive is a filled error action', () {
      const action = AppOverlayAction.destructive(label: 'Xoá');
      expect(action.isPrimary, isTrue);
      expect(action.type, BaseButtonType.error);
    });
  });

  group('build', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      BennyStyleInitializer.ensureInitialized();
    });

    testWidgets('renders the label and runs onPressed on tap', (tester) async {
      var pressed = 0;
      final action = AppOverlayAction(label: 'Confirm', onPressed: () => pressed++);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(builder: (context) => action.build(context)),
          ),
        ),
      );

      expect(find.text('Confirm'), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pump();

      expect(pressed, 1);
    });
  });
}
