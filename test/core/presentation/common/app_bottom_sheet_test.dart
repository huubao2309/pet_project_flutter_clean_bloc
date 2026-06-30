import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/common/app_bottom_sheet.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  testWidgets('show displays the sheet content for the given context',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => AppBottomSheet.show<void>(
                context: context,
                title: 'Chọn ngân hàng',
                body: const Text('sheet-body'),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Chọn ngân hàng'), findsOneWidget);
    expect(find.text('sheet-body'), findsOneWidget);
  });

  test('show resolves to null when no navigator context is available',
      () async {
    expect(await AppBottomSheet.show<int>(title: 'x'), isNull);
  });
}
