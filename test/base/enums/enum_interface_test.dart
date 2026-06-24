import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/base/enums/enum_interface.dart';

enum _SampleEnum implements EnumInterface {
  first('first', 'First'),
  second('second', 'Second');

  const _SampleEnum(this.rawValue, this.displayValue);

  @override
  final String rawValue;

  @override
  final String displayValue;
}

void main() {
  group('EnumInterface', () {
    test('implementations expose rawValue and displayValue', () {
      expect(_SampleEnum.first.rawValue, 'first');
      expect(_SampleEnum.first.displayValue, 'First');
      expect(_SampleEnum.second.rawValue, 'second');
      expect(_SampleEnum.second.displayValue, 'Second');
    });

    test('an implementation is assignable to EnumInterface', () {
      const EnumInterface value = _SampleEnum.first;
      expect(value, isA<EnumInterface>());
    });
  });
}
