import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entities/sign_up_result.dart';
import '../../domain/use_cases/sign_up_use_case.dart';
import 'sign_up_state.dart';

/// View model (MVVM) for the sign-up screen.
///
/// Holds the phone field with live validation and, on "Continue", submits via
/// [SignUpUseCase]. A `verify_otp` challenge is surfaced as [SignUpState.otpChallenge]
/// so the View can route to the OTP screen. The View calls these plain methods.
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

  Future<void> signUp() async {
    if (!currentState.canSubmit || currentState.isLoading) {
      return;
    }
    setState(currentState.copyWith(isLoading: true, clearError: true));
    try {
      final result = await _signUpUseCase.execute(
        SignUpParams(phone: currentState.phone),
      );
      switch (result) {
        // OTP step required → the View routes to the verification screen.
        case SignUpOtpRequired(:final challenge):
          setState(
            currentState.copyWith(isLoading: false, otpChallenge: challenge),
          );
        // Completed outright → the View routes to login.
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
