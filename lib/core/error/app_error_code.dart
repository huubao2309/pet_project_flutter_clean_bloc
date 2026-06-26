/// Stable, machine-readable error codes raised by the data/domain layers.
///
/// This is the contract between the layers: data sources and repositories throw
/// an [AppException] carrying one of these codes (never a localized string), and
/// the presentation layer maps the code to user-facing copy. Keeping it a plain
/// enum means the inner layers stay free of any UI / localization framework
/// (the Dependency Rule), and the exhaustive `switch` in the presentation mapper
/// forces every new code to get a message.
enum AppErrorCode {
  /// Unclassified failure.
  unknown,

  /// Recoverable server-side failure.
  server,

  /// No / failed connectivity.
  network,

  /// The request exceeded the connect/receive timeout.
  networkTimeout,

  /// Invalid or expired session (e.g. a rejected token).
  auth,

  /// Local persistence failure.
  cache,

  /// Input failed validation at a boundary.
  validation,

  /// The account is blocked (a hard stop) — see `BlockReason` for the cause.
  accountBlocked,

  /// The phone number is blocked from the operation (a hard stop).
  phoneBlocked,

  // ── Per-endpoint default failures ─────────────────────────────────────────
  loginFailed,
  signupFailed,
  forgotFailed,
  resetFailed,
  verifyOtpFailed,
  registerPasswordFailed,
  logoutFailed,
  changePasswordFailed,
}
