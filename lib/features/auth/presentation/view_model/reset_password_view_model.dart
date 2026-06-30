import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/app_error_localizer.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import 'reset_password_state.dart';

class ResetPasswordViewModel extends ViewModel<ResetPasswordState> {
  ResetPasswordViewModel({required ResetPasswordUseCase resetPasswordUseCase})
      : _resetPasswordUseCase = resetPasswordUseCase,
        super(const ResetPasswordState());

  final ResetPasswordUseCase _resetPasswordUseCase;

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

  Future<void> resetPassword() async {
    if (!currentState.canSubmit) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      await _resetPasswordUseCase.execute(currentState.password);
      setState(currentState.copyWith(isLoading: false, isResetSuccess: true));
    } on AppException catch (e) {
      setState(
        currentState.copyWith(
          isLoading: false,
          errorMessage: AppErrorLocalizer.localize(e),
        ),
      );
    }
  }
}
