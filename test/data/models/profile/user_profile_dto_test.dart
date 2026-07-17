import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/user_profile_dto.dart';

void main() {
  group('UserProfileDto', () {
    test('fromJson parses required fields and optional email', () {
      final dto = UserProfileDto.fromJson({
        'id': 'u1',
        'fullName': 'Jane Doe',
        'phone': '0900000000',
        'email': 'jane@example.com',
      });
      expect(dto.id, 'u1');
      expect(dto.fullName, 'Jane Doe');
      expect(dto.phone, '0900000000');
      expect(dto.email, 'jane@example.com');
    });

    test('fromJson leaves email null when absent', () {
      final dto = UserProfileDto.fromJson({
        'id': 'u1',
        'fullName': 'Jane Doe',
        'phone': '0900000000',
      });
      expect(dto.email, isNull);
    });

    test('toJson outputs all keys (fullName uses camelCase key)', () {
      const dto = UserProfileDto(
        id: 'u1',
        fullName: 'Jane Doe',
        phone: '0900000000',
        email: 'jane@example.com',
      );
      expect(dto.toJson(), {
        'id': 'u1',
        'fullName': 'Jane Doe',
        'phone': '0900000000',
        'email': 'jane@example.com',
      });
    });

    test('toEntity maps all fields', () {
      const dto = UserProfileDto(
        id: 'u1',
        fullName: 'Jane Doe',
        phone: '0900000000',
        email: 'jane@example.com',
      );
      final entity = dto.toEntity();
      expect(entity.id, 'u1');
      expect(entity.fullName, 'Jane Doe');
      expect(entity.phone, '0900000000');
      expect(entity.email, 'jane@example.com');
    });

    test('toEntity preserves null email', () {
      const dto = UserProfileDto(
        id: 'u1',
        fullName: 'Jane Doe',
        phone: '0900000000',
      );
      expect(dto.toEntity().email, isNull);
    });
  });
}
