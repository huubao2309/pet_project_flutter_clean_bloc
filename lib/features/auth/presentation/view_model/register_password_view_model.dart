import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/register_password_use_case.dart';
import 'register_password_state.dart';

/// View model (MVVM) for the register-password screen (final sign-up step).
///
/// Holds the new password + confirmation with live rule validation and submits
/// via [RegisterPasswordUseCase] together with the session token from the
/// verify-otp step. On success the user is signed in. The View calls these
/// plain methods.
class RegisterPasswordViewModel extends ViewModel<RegisterPasswordState> {
  RegisterPasswordViewModel({
    required RegisterPasswordUseCase registerPasswordUseCase,
    required String sessionToken,
  })  : _registerPasswordUseCase = registerPasswordUseCase,
        super(RegisterPasswordState(sessionToken: sessionToken));

  final RegisterPasswordUseCase _registerPasswordUseCase;

  void onPasswordChanged(String value) {
    setState(
      currentState.copyWith(
        password: value,
        strength: PasswordStrength(
          hasMinLength: Validators.hasMinLength(value),
          hasSpecialChar: Validators.hasSpecialChar(value),
          hasNumber: Validators.hasNumber(value),
          hasCapital: Validators.hasCapital(value),
        ),
      ),
    );
  }

  void onConfirmPasswordChanged(String value) {
    setState(currentState.copyWith(confirmPassword: value));
  }

  Future<void> submit() async {
    if (!currentState.canSubmit || currentState.isLoading) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      await _registerPasswordUseCase.execute(
        RegisterPasswordParams(
          password: currentState.password,
          sessionToken: currentState.sessionToken,
        ),
      );
      setState(currentState.copyWith(isLoading: false, isSuccess: true));
    } on AppException catch (e) {
      setState(
        currentState.copyWith(isLoading: false, errorMessage: e.message),
      );
    }
  }
}
