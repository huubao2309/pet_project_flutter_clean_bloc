import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/login_result.dart';
import '../../domain/use_cases/login_use_case.dart';
import '../../domain/use_cases/logout_use_case.dart';
import 'auth_state.dart';

/// View model (MVVM) for the auth feature.
///
/// Replaces the previous `AuthBloc`: instead of dispatching events, the View
/// calls these plain methods. Backed by [ViewModel] (a `Cubit` today) so the
/// only state-management coupling lives in core/presentation.
class AuthViewModel extends ViewModel<AuthState> {
  AuthViewModel({
    required LoginUseCase loginUseCase,
    required LogoutUseCase logoutUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  Future<void> login({required String phone, required String password}) async {
    setState(const AuthLoading());
    try {
      final result = await _loginUseCase.execute(
        LoginParams(phone: phone, password: password),
      );
      switch (result) {
        case LoginAuthenticated():
          setState(const AuthAuthenticated());
        case LoginOtpRequired(:final challenge):
          setState(AuthOtpRequired(challenge));
      }
    } on AccountBlockedException catch (e) {
      setState(AuthBlocked(e.reason, e.message));
    } on AppException catch (e) {
      setState(AuthFailure(e.message));
    }
  }

  /// Returns the screen to the login form after a hard stop (e.g. the user
  /// taps "Back to log in" on the locked screen).
  void reset() => setState(const AuthInitial());

  Future<void> logout() async {
    setState(const AuthLoading());
    try {
      await _logoutUseCase.execute(const NoParams());
      setState(const AuthUnauthenticated());
    } on AppException catch (e) {
      setState(AuthFailure(e.message));
    }
  }
}
