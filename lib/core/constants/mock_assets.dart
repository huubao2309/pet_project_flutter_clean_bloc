abstract final class MockAssets {
  static const _base = 'assets/mock/';

  // App update scenarios.
  static const _appUpdateMock = '${_base}app_update_mock/';
  static const appUpdateForce = '${_appUpdateMock}app_update_force.json';
  static const appUpdateOptional = '${_appUpdateMock}app_update_optional.json';
  static const appUpdateNone = '${_appUpdateMock}app_update_none.json';

  static const _authMock = '${_base}auth_mock/';
  static const loginSuccess = '${_authMock}login_success.json';
  static const loginNeedVerifyOtp =
      '${_authMock}login_need_verify_otp_success.json';
  static const loginOtpLimitExceeded =
      '${_authMock}login_otp_limit_exceeded_failed.json';
  static const loginAccountIsDeleted =
      '${_authMock}login_account_is_deleted_failed.json';
  static const loginFailed = '${_authMock}login_failed.json';
  static const logoutSuccess = '${_authMock}logout_success.json';
  static const logoutFailed = '${_authMock}logout_failed.json';
  static const signupSuccess = '${_authMock}signup_success.json';
  static const signupIsBlocked = '${_authMock}signup_is_blocked_failed.json';
  static const signupFailed = '${_authMock}signup_failed.json';
  static const verifyOtpLoginSuccess =
      '${_authMock}verify_otp_login_flow_success.json';
  static const verifyOtpSignupSuccess =
      '${_authMock}verify_otp_signup_flow_success.json';

  // Forgot-password flow → challenge_type "reset_password": carries a session
  // token to set a new password next.
  static const verifyOtpForgotSuccess =
      '${_authMock}verify_otp_forgot_password_flow_success.json';

  // Wrong/expired OTP → failure (drives the "code invalid" error / lock).
  static const verifyOtpIncorrectFailed =
      '${_authMock}verify_otp_incorrect_failed.json';

  // Register-password (sign-up flow, after OTP) → returns auth tokens.
  static const registerPasswordSuccess =
      '${_authMock}register_password_success.json';
  static const registerPasswordFailed =
      '${_authMock}register_password_failed.json';

  // Forgot-password: send reset code → challenge_type "verify_otp".
  static const forgotPasswordSuccess =
      '${_authMock}forgot_password_success.json';
  static const forgotPasswordFailed = '${_authMock}forgot_password_failed.json';

  // Reset-password (forgot flow) → challenge_type "verify_login": the user must
  // log in again with the new password.
  static const resetPasswordSuccess = '${_authMock}reset_password_success.json';
  static const resetPasswordFailed = '${_authMock}reset_password_failed.json';

  // User scenarios.
  static const _userMock = '${_base}user_mock/';
  static const profileSuccess = '${_userMock}get_profile_success.json';
  static const changePasswordSuccess =
      '${_userMock}change_password_success.json';
  static const changePasswordFailed = '${_userMock}change_password_failed.json';
}
