import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/utils/debug_helper.dart';

void main() {
  group('DebugHelper.isDebugMode', () {
    test('mirrors the compile-time kDebugMode flag', () {
      expect(DebugHelper.isDebugMode(), kDebugMode);
    });
  });
}
