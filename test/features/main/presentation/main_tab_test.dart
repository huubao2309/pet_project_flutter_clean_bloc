import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/main/presentation/main_tab.dart';

void main() {
  test('defines the five CTV tabs in order', () {
    expect(MainTab.values, [
      MainTab.home,
      MainTab.history,
      MainTab.qr,
      MainTab.commission,
      MainTab.profile,
    ]);
  });

  test('only the QR tab is a center button', () {
    expect(MainTab.qr.isCenter, isTrue);
    for (final tab in MainTab.values.where((t) => t != MainTab.qr)) {
      expect(tab.isCenter, isFalse);
    }
  });

  test('each tab carries a label key and icons', () {
    for (final tab in MainTab.values) {
      expect(tab.labelKey, startsWith('nav.'));
      expect(tab.icon, isA<IconData>());
      expect(tab.activeIcon, isA<IconData>());
    }
  });
}
