import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/benny_range_slider.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';

void main() {
  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    BennyStyleInitializer.ensureInitialized();
  });

  Future<void> pump(WidgetTester tester, Widget child) => tester.pumpWidget(
        MaterialApp(home: Scaffold(body: child)),
      );

  testWidgets('renders an interactive RangeSlider when onChanged is provided',
      (tester) async {
    await pump(
      tester,
      BennyRangeSlider(
        values: const RangeValues(0.2, 0.8),
        onChanged: (_) {},
      ),
    );

    final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
    expect(slider.values, const RangeValues(0.2, 0.8));
    expect(slider.onChanged, isNotNull);
  });

  testWidgets('is disabled (no onChanged) when none is given', (tester) async {
    await pump(
      tester,
      const BennyRangeSlider(values: RangeValues(0, 1)),
    );

    final slider = tester.widget<RangeSlider>(find.byType(RangeSlider));
    expect(slider.onChanged, isNull);
  });
}
