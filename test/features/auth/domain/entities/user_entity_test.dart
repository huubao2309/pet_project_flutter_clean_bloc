import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('stores all fields', () {
      const user = UserEntity(
        id: 'u1',
        fullName: 'Nguyen Van A',
        phone: '0900000000',
        email: 'a@example.com',
      );
      expect(user.id, 'u1');
      expect(user.fullName, 'Nguyen Van A');
      expect(user.phone, '0900000000');
      expect(user.email, 'a@example.com');
    });

    test('email is optional and defaults to null', () {
      const user = UserEntity(id: 'u2', fullName: 'B', phone: '0911111111');
      expect(user.email, isNull);
    });
  });
}
