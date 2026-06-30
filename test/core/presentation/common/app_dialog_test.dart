import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_dialog.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  testWidgets('show displays the dialog content for the given context',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppDialog.show<void>(
                context: context,
                title: 'Đăng xuất',
                message: 'Bạn chắc chứ?',
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Đăng xuất'), findsOneWidget);
    expect(find.text('Bạn chắc chứ?'), findsOneWidget);
  });

  test('show resolves to null when no navigator context is available',
      () async {
    expect(await AppDialog.show<bool>(title: 'x'), isNull);
  });
}
