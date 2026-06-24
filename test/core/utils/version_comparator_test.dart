import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/version_comparator.dart';

void main() {
  group('VersionComparator.compare', () {
    test('compares segments numerically, not lexically', () {
      expect(VersionComparator.compare('2.10.0', '2.9.0'), greaterThan(0));
      expect(VersionComparator.compare('2.9.0', '2.10.0'), lessThan(0));
    });

    test('returns 0 for equal versions', () {
      expect(VersionComparator.compare('1.2.3', '1.2.3'), 0);
    });

    test('treats missing trailing segments as zero', () {
      expect(VersionComparator.compare('2.1', '2.1.0'), 0);
      expect(VersionComparator.compare('2.1.0', '2.1'), 0);
    });

    test('ignores build/pre-release suffix after + or -', () {
      expect(VersionComparator.compare('1.0.0+5', '1.0.0'), 0);
      expect(VersionComparator.compare('1.0.0-beta', '1.0.0'), 0);
    });

    test('treats non-numeric segments as zero', () {
      expect(VersionComparator.compare('1.x.0', '1.0.0'), 0);
    });

    test('detects greater major version', () {
      expect(VersionComparator.compare('3.0.0', '2.99.99'), greaterThan(0));
    });
  });

  group('VersionComparator.isLower', () {
    test('true when strictly lower', () {
      expect(VersionComparator.isLower('1.0.0', '1.0.1'), isTrue);
    });

    test('false when equal or higher', () {
      expect(VersionComparator.isLower('1.0.1', '1.0.1'), isFalse);
      expect(VersionComparator.isLower('1.0.2', '1.0.1'), isFalse);
    });
  });
}
