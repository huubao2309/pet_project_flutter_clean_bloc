import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/use_case/use_case.dart';

void main() {
  group('NoParams', () {
    test('can be const-constructed', () {
      const a = NoParams();
      const b = NoParams();
      // const instances are canonicalized to the same object.
      expect(identical(a, b), isTrue);
    });

    test('is a NoParams instance', () {
      expect(const NoParams(), isA<NoParams>());
    });
  });
}
