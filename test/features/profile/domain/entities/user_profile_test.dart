import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/entities/user_profile.dart';

void main() {
  group('UserProfile', () {
    test('stores all fields', () {
      const profile = UserProfile(
        id: 'p1',
        fullName: 'Tran Thi B',
        phone: '0922222222',
        email: 'b@example.com',
      );
      expect(profile.id, 'p1');
      expect(profile.fullName, 'Tran Thi B');
      expect(profile.phone, '0922222222');
      expect(profile.email, 'b@example.com');
    });

    test('email is optional and defaults to null', () {
      const profile = UserProfile(id: 'p2', fullName: 'C', phone: '093');
      expect(profile.email, isNull);
    });
  });
}
