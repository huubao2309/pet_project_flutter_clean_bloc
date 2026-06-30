import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/presentation/widgets/custom_range_thumb_shape.dart';

void main() {
  test('getPreferredSize is a square of side 2 * thumbRadius', () {
    const shape = CustomRangeThumbShape(thumbRadius: 12, fillColor: Color(0xFF000000));
    expect(shape.getPreferredSize(true, false), const Size(24, 24));
    expect(shape.getPreferredSize(false, true), const Size(24, 24));
  });

  test('has the documented defaults', () {
    const shape = CustomRangeThumbShape(thumbRadius: 10, fillColor: Color(0xFFFFFFFF));
    expect(shape.padding, 4);
    expect(shape.borderWidth, 1);
    expect(shape.borderColor, isNull);
    expect(shape.middleColor, isNull);
  });

  test('is a RangeSliderThumbShape', () {
    const shape = CustomRangeThumbShape(thumbRadius: 8, fillColor: Color(0xFF112233));
    expect(shape, isA<RangeSliderThumbShape>());
  });
}
