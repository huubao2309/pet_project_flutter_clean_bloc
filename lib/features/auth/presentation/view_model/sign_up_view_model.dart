import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/sign_up_result.dart';
import '../../domain/use_cases/sign_up_use_case.dart';
import 'sign_up_state.dart';

/// View model (MVVM) for the sign-up screen.
///
/// Holds form state and live validation (phone + 4 password rules) and submits
/// via [SignUpUseCase]. The View calls these plain methods.
class SignUpViewModel extends ViewModel<SignUpState> {
  SignUpViewModel({required SignUpUseCase signUpUseCase})
      : _signUpUseCase = signUpUseCase,
        super(const SignUpState());

  final SignUpUseCase _signUpUseCase;

  void onPhoneChanged(String value) {
    setState(
      currentState.copyWith(
        phone: value,
        isPhoneValid: Validators.isPhoneValid(value),
      ),
    );
  }

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

  void onReceiveUpdatesChanged({required bool value}) {
    setState(currentState.copyWith(receiveUpdates: value));
  }

  Future<void> signUp() async {
    if (!currentState.canSubmit) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _signUpUseCase.execute(
        SignUpParams(
          phone: currentState.phone,
          password: currentState.password,
          receiveUpdates: currentState.receiveUpdates,
        ),
      );
      switch (result) {
        // OTP step required → the View routes to the verification screen.
        case SignUpOtpRequired(:final challenge):
          setState(
            currentState.copyWith(isLoading: false, otpChallenge: challenge),
          );
        // Completed outright → the View routes to login (old behavior).
        case SignUpCompleted():
          setState(currentState.copyWith(isLoading: false, isSuccess: true));
      }
    } on PhoneBlockedException catch (_) {
      // Hard stop (phone blocked from registering): the View shows a
      // full-screen error, not a snackbar. Must be caught before AppException.
      setState(currentState.copyWith(isLoading: false, isBlocked: true));
    } on AppException catch (e) {
      setState(currentState.copyWith(isLoading: false, errorMessage: e.message));
    }
  }
}
