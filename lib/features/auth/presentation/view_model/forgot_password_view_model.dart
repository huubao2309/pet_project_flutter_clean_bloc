import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/app_error_localizer.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/use_cases/forgot_password_use_case.dart';
import 'forgot_password_state.dart';

class ForgotPasswordViewModel extends ViewModel<ForgotPasswordState> {
  ForgotPasswordViewModel({
    required ForgotPasswordUseCase forgotPasswordUseCase,
  })  : _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const ForgotPasswordState());

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  void onPhoneChanged(String value) {
    setState(
      currentState.copyWith(
        phone: value,
        isPhoneValid: Validators.isPhoneValid(value.trim()),
      ),
    );
  }

  Future<void> forgotPassword() async {
    if (!currentState.canSubmit) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      final challenge =
          await _forgotPasswordUseCase.execute(currentState.phone.trim());
      setState(
        currentState.copyWith(isLoading: false, otpChallenge: challenge),
      );
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
