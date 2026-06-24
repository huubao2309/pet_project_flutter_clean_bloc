import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/data/models/request/change_password_request_dto.dart';

void main() {
  group('ChangePasswordRequestDto', () {
    test('fromJson maps snake_case current_password/new_password', () {
      final dto = ChangePasswordRequestDto.fromJson({
        'current_password': 'old',
        'new_password': 'new',
      });
      expect(dto.currentPassword, 'old');
      expect(dto.newPassword, 'new');
    });

    test('toJson outputs snake_case keys', () {
      const dto = ChangePasswordRequestDto(
        currentPassword: 'old',
        newPassword: 'new',
      );
      expect(dto.toJson(), {
        'current_password': 'old',
        'new_password': 'new',
      });
    });
  });
}
