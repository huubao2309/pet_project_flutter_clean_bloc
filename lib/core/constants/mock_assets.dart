abstract final class MockAssets {
  static const _base = 'assets/mock/';

  static const loginSuccess = '${_base}auth_mock/login_success.json';
  static const loginOtpLimitExceeded = '${_base}auth_mock/login_otp_limit_exceeded_failed.json';
  static const loginAccountIsDeleted = '${_base}auth_mock/login_account_is_deleted_failed.json';
  static const loginFailed = '${_base}auth_mock/login_failed.json';
  static const logoutSuccess = '${_base}auth_mock/logout_success.json';
  static const logoutFailed = '${_base}auth_mock/logout_failed.json';
  static const signupSuccess = '${_base}auth_mock/signup_success.json';
  static const signupIsBlocked = '${_base}auth_mock/signup_is_blocked_failed.json';
  static const signupFailed = '${_base}auth_mock/signup_failed.json';

  // App update scenarios.
  static const appUpdateForce = '${_base}app_update_mock/app_update_force.json';
  static const appUpdateOptional = '${_base}app_update_mock/app_update_optional.json';
  static const appUpdateNone = '${_base}app_update_mock/app_update_none.json';
}
