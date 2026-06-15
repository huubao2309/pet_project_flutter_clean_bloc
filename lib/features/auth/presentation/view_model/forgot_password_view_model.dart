import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../domain/use_cases/forgot_password_use_case.dart';
import 'forgot_password_state.dart';

class ForgotPasswordViewModel extends ViewModel<ForgotPasswordState> {
  ForgotPasswordViewModel({required ForgotPasswordUseCase forgotPasswordUseCase})
      : _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const ForgotPasswordState());

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  void onEmailChanged(String value) {
    setState(currentState.copyWith(email: value));
  }

  Future<void> forgotPassword() async {
    if (!currentState.canSubmit) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      await _forgotPasswordUseCase.execute(currentState.email.trim());
      setState(currentState.copyWith(isLoading: false, isEmailSent: true));
    } on AppException catch (e) {
      setState(
        currentState.copyWith(isLoading: false, errorMessage: e.message),
      );
    }
  }
}
