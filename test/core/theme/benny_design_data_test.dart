import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_design_data.dart';

void main() {
  group('brandColor ramp', () {
    test('signature navy #1A3C5E sits at the 600 step', () {
      expect(BennyDesignData.brandColor['600'], '#1A3C5E');
    });

    test('defines every ramp step 25..900', () {
      expect(
        BennyDesignData.brandColor.keys,
        containsAll(<String>[
          '25',
          '50',
          '100',
          '200',
          '300',
          '400',
          '500',
          '600',
          '700',
          '800',
          '900',
        ]),
      );
    });

    test('every value is a hex colour string', () {
      for (final value in BennyDesignData.brandColor.values) {
        expect(value, matches(RegExp(r'^#[0-9A-Fa-f]{6}$')), reason: value);
      }
    });
  });

  test('typography tokens are constructed', () {
    expect(BennyDesignData.dataSourceHeading, isNotNull);
    expect(BennyDesignData.dataSourceParagraph, isNotNull);
    expect(BennyDesignData.dataSourceCaption, isNotNull);
  });
}
