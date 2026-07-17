/// In-memory holder for the short-lived `session_token` of a *pre-authentication*
/// flow (sign-up, forgot-password, or login re-verification).
///
/// Before the user has an `access_token`, this token is how the backend knows
/// *which* in-progress user a follow-up step belongs to — verify-otp,
/// register-password, reset-password. It is the pre-login equivalent of the
/// access/refresh tokens in secure storage: a credential the data layer owns and
/// the presentation layer never sees.
///
/// Flow-scoped and transient: the repository [save]s it when a step issues a
/// token, [require]s it on the next step, and [clear]s it when the flow ends
/// (authenticated, password reset, or aborted). Kept in memory on purpose — it
/// must not outlive the app session.
class PreAuthSession {
  String? _token;

  /// The active pre-auth session token, or null when no flow is in progress.
  String? get token => _token;

  /// Stores the token issued by the latest pre-auth step.
  void save(String token) => _token = token;

  /// The active token, or throws if a step ran without one being issued first
  /// (a programming error — the flow was entered out of order).
  String require() =>
      _token ?? (throw StateError('No pre-auth session is active.'));

  /// Ends the pre-auth flow (call on success or when abandoning it).
  void clear() => _token = null;
}
