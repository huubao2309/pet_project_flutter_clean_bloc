import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/use_case/use_case.dart';
import '../../domain/use_cases/get_current_user_use_case.dart';
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
    required GetCurrentUserUseCase getCurrentUserUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _getCurrentUserUseCase = getCurrentUserUseCase,
        super(const AuthInitial());

  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  Future<void> checkAuth() async {
    try {
      final user = await _getCurrentUserUseCase.execute(const NoParams());
      setState(user != null ? AuthAuthenticated(user) : const AuthUnauthenticated());
    } on AppException catch (e) {
      setState(AuthFailure(e.message));
    }
  }

  Future<void> login({required String phone, required String password}) async {
    setState(const AuthLoading());
    try {
      final user = await _loginUseCase.execute(
        LoginParams(phone: phone, password: password),
      );
      setState(AuthAuthenticated(user));
    } on AccountBlockedException catch (e) {
      // Hard stop (too many wrong OTP entries, deleted account, …): the View
      // shows a full-screen error, not a snackbar. The reason drives which
      // message. Must be caught before AppException.
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
      // Logout failed → keep the session and surface the error to the UI.
      setState(AuthFailure(e.message));
    }
  }
}
