sealed class AuthEvent {
  const AuthEvent();
}

final class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({required this.phone, required this.password});
  final String phone;
  final String password;
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}
