import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_overlay_action.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/widgets/app_dialog_content.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/widgets/app_overlay_icon.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Future<void> pump(WidgetTester tester, Widget child) =>
      tester.pumpWidget(MaterialApp(home: Scaffold(body: child)));

  testWidgets('renders title and message when supplied', (tester) async {
    await pump(
      tester,
      const AppDialogContent(title: 'Đăng xuất', message: 'Bạn chắc chứ?'),
    );

    expect(find.text('Đăng xuất'), findsOneWidget);
    expect(find.text('Bạn chắc chứ?'), findsOneWidget);
  });

  testWidgets('renders the preset icon when iconType is set', (tester) async {
    await pump(
      tester,
      const AppDialogContent(
        iconType: AppOverlayIconType.warning,
        title: 'Cảnh báo',
      ),
    );

    expect(find.byType(AppOverlayIcon), findsOneWidget);
    expect(find.byIcon(Icons.priority_high_rounded), findsOneWidget);
  });

  testWidgets('renders the footer actions', (tester) async {
    await pump(
      tester,
      const AppDialogContent(
        title: 't',
        actions: [AppOverlayAction(label: 'Đóng')],
      ),
    );

    expect(find.text('Đóng'), findsOneWidget);
  });

  testWidgets('renders custom content', (tester) async {
    await pump(
      tester,
      const AppDialogContent(content: Text('custom-body')),
    );

    expect(find.text('custom-body'), findsOneWidget);
  });
}
