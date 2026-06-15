import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import 'reset_password_state.dart';

class ResetPasswordViewModel extends ViewModel<ResetPasswordState> {
  ResetPasswordViewModel({
    required ResetPasswordUseCase resetPasswordUseCase,
    String token = '',
  })  : _resetPasswordUseCase = resetPasswordUseCase,
        _token = token,
        super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPasswordUseCase;

  /// Reset token coming from the email deep link (empty in the stub flow).
  final String _token;

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

  Future<void> resetPassword() async {
    if (!currentState.canSubmit) return;
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      await _resetPasswordUseCase.execute(
        ResetPasswordParams(
          newPassword: currentState.password,
          token: _token,
        ),
      );
      setState(currentState.copyWith(isLoading: false, isResetSuccess: true));
    } on AppException catch (e) {
      setState(
        currentState.copyWith(isLoading: false, errorMessage: e.message),
      );
    }
  }
}
