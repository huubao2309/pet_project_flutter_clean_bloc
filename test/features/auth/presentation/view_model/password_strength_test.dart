import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/auth/presentation/view_model/password_strength.dart';

void main() {
  test('empty constructor sets every flag false', () {
    const s = PasswordStrength.empty();
    expect(s.hasMinLength, isFalse);
    expect(s.hasSpecialChar, isFalse);
    expect(s.hasNumber, isFalse);
    expect(s.hasCapital, isFalse);
    expect(s.isAllValid, isFalse);
  });

  test('isAllValid only when every rule passes', () {
    const allValid = PasswordStrength(
      hasMinLength: true,
      hasSpecialChar: true,
      hasNumber: true,
      hasCapital: true,
    );
    expect(allValid.isAllValid, isTrue);

    const missingOne = PasswordStrength(
      hasMinLength: true,
      hasSpecialChar: true,
      hasNumber: true,
      hasCapital: false,
    );
    expect(missingOne.isAllValid, isFalse);
  });
}
