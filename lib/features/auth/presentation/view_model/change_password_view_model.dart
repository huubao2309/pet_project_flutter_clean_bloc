import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/app_error_localizer.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../../profile/domain/use_cases/change_password_use_case.dart';
import 'change_password_state.dart';

/// View model (MVVM) for the change-password screen (reached from Profile).
///
/// Holds the current/new/confirm password fields with live validation (the 4
/// new-password rules + the confirmation match) and submits via
/// [ChangePasswordUseCase]. The View calls these plain methods.
class ChangePasswordViewModel extends ViewModel<ChangePasswordState> {
  ChangePasswordViewModel({required ChangePasswordUseCase changePasswordUseCase})
      : _changePasswordUseCase = changePasswordUseCase,
        super(const ChangePasswordState());

  final ChangePasswordUseCase _changePasswordUseCase;

  void onCurrentPasswordChanged(String value) {
    setState(currentState.copyWith(currentPassword: value));
  }

  void onNewPasswordChanged(String value) {
    setState(
      currentState.copyWith(
        newPassword: value,
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

  Future<void> changePassword() async {
    if (!currentState.canSubmit) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      await _changePasswordUseCase.execute(
        ChangePasswordParams(
          currentPassword: currentState.currentPassword,
          newPassword: currentState.newPassword,
        ),
      );
      setState(currentState.copyWith(isLoading: false, isSuccess: true));
    } on AppException catch (e) {
      setState(
        currentState.copyWith(isLoading: false, errorMessage: AppErrorLocalizer.localize(e)),
      );
    }
  }
}
