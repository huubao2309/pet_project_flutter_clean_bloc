import 'package:benny_style/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/app_dark_colors.dart';

void main() {
  final colors = AppDarkColors();

  test('is an AppColors so it can swap in for the light palette', () {
    expect(colors, isA<AppColors>());
  });

  test('overrides the surface tokens with the dark palette', () {
    expect(colors.surfaceBackground, const Color(0xFF0D1722));
    expect(colors.white, const Color(0xFF17232F));
    expect(colors.surfaceElevated, const Color(0xFF1C2B3A));
  });

  test('overrides the semantic ramps with dark variants', () {
    expect(colors.error500, const Color(0xFFF2745A));
    expect(colors.success500, const Color(0xFF34D17F));
    expect(colors.secondary600, const Color(0xFFECB237));
    expect(colors.brand800, const Color(0xFFE9EEF3));
  });

  test('hero gradient stays navy so on-navy white text reads', () {
    expect(colors.heroTop, const Color(0xFF1E3E5C));
    expect(colors.heroBottom, const Color(0xFF11202E));
  });
}
