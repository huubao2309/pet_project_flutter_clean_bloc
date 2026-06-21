import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/storage/secure_storage/secure_storage.dart';
import '../../domain/entities/login_result.dart';
import '../../domain/entities/otp_challenge.dart';
import '../../domain/entities/sign_up_result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/verify_otp_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/pre_auth_session.dart';
import '../models/request/change_password_request_dto.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/register_password_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../models/request/verify_otp_request_dto.dart';

/// The single [AuthRepository] implementation, backed by an
/// [AuthRemoteDataSource] (real API or fake mock — chosen in DI) and
/// [SecureStorage] for token persistence.
///
/// The data layer owns DTO construction/serialization: the domain passes plain
/// values, this class maps them to request DTOs and maps response DTOs back to
/// domain entities. It also owns session persistence — the access/refresh
/// tokens in [SecureStorage] and the transient pre-auth [PreAuthSession] token
/// used to carry a sign-up / forgot-password flow across its steps.
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorage secureStorage,
    required PreAuthSession preAuthSession,
  })  : _remoteDataSource = remoteDataSource,
        _secureStorage = secureStorage,
        _preAuthSession = preAuthSession;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorage _secureStorage;
  final PreAuthSession _preAuthSession;

  /// `challenge_type` value that means an OTP step is required before the
  /// session is granted (the backend couldn't authenticate outright).
  static const _challengeVerifyOtp = 'verify_otp';

  @override
  Future<LoginResult> login({
    required String phone,
    required String password,
  }) async {
    final data = await _remoteDataSource.login(
      LoginRequestDto(phone: phone, password: password),
    );

    // OTP challenge: the user is NOT authenticated yet, so there are no tokens
    // to persist. Hand the challenge parameters to the presentation layer,
    // which routes to the OTP screen.
    if (data.challengeType == _challengeVerifyOtp) {
      // Stash the pre-auth session token so the verify-otp step can use it.
      _preAuthSession.save(data.sessionToken ?? '');
      return LoginOtpRequired(
        OtpChallenge(
          resendSecs: data.otpResendSecs ?? 0,
          // Missing/null → 0 → the "Resend" button is enabled immediately.
          enableResendSecs: data.otpEnableResendSecs ?? 0,
        ),
      );
    }

    // No challenge → the response must carry the session tokens. Fail fast on a
    // malformed payload rather than persisting half a session. Login does not
    // return the user profile — it is fetched separately on the main screen.
    final accessToken = data.accessToken;
    final refreshToken = data.refreshToken;
    if (accessToken == null || refreshToken == null) {
      throw ServerException(message: 'errors.login_failed'.tr());
    }

    // Persist tokens so the user stays logged in after restarting the app.
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    return const LoginAuthenticated();
  }

  @override
  Future<SignUpResult> signUp({
    required String phone,
    bool? receiveUpdates,
  }) async {
    final data = await _remoteDataSource.signUp(
      SignUpRequestDto(
        phone: phone,
        // The data layer owns transport concerns like the API language code.
        language: _defaultLanguage,
        statusUpdate: receiveUpdates,
      ),
    );
    // A verify_otp challenge → the View routes to the OTP screen; otherwise the
    // registration is complete.
    if (data.requiresOtpVerification) {
      _preAuthSession.save(data.sessionToken ?? '');
      return SignUpOtpRequired(data.toEntity());
    }
    return const SignUpCompleted();
  }

  @override
  Future<VerifyOtpResult> verifyOtp({required String code}) async {
    final data = await _remoteDataSource.verifyOtp(
      VerifyOtpRequestDto(code: code, sessionToken: _preAuthSession.require()),
    );

    // Authenticated (challenge_type "none"): persist tokens when present and end
    // the pre-auth flow.
    if (data.isAuthenticated) {
      final accessToken = data.accessToken;
      final refreshToken = data.refreshToken;
      if (accessToken != null && refreshToken != null) {
        await _secureStorage.saveAccessToken(accessToken);
        await _secureStorage.saveRefreshToken(refreshToken);
      }
      _preAuthSession.clear();
      return const VerifyOtpAuthenticated();
    }

    // Sign-up flow: phone confirmed, a password must still be set. The response
    // issues a fresh session token — carry it into the register-password step.
    if (data.requiresPasswordRegistration) {
      _preAuthSession.save(data.sessionToken ?? '');
      return const VerifyOtpRegisterPassword();
    }
    // Forgot-password flow: confirmed, the user must set a new password.
    if (data.requiresPasswordReset) {
      _preAuthSession.save(data.sessionToken ?? '');
      return const VerifyOtpResetPassword();
    }
    _preAuthSession.clear();
    return const VerifyOtpAuthenticated();
  }

  @override
  Future<void> registerPassword({required String password}) async {
    final data = await _remoteDataSource.registerPassword(
      RegisterPasswordRequestDto(
        password: password,
        sessionToken: _preAuthSession.require(),
      ),
    );
    // Success completes the account and signs the user in → persist tokens and
    // end the pre-auth flow.
    final accessToken = data.accessToken;
    final refreshToken = data.refreshToken;
    if (accessToken == null || refreshToken == null) {
      throw ServerException(message: 'errors.register_password_failed'.tr());
    }
    await _secureStorage.saveAccessToken(accessToken);
    await _secureStorage.saveRefreshToken(refreshToken);
    _preAuthSession.clear();
  }

  @override
  Future<OtpChallenge> forgotPassword({required String phone}) async {
    final data = await _remoteDataSource.forgotPassword(
      ForgotPasswordRequestDto(phone: phone),
    );
    // Stash the pre-auth session token so verify-otp / reset-password can use it.
    _preAuthSession.save(data.sessionToken ?? '');
    return data.toEntity();
  }

  @override
  Future<void> resetPassword({required String newPassword}) async {
    await _remoteDataSource.resetPassword(
      ResetPasswordRequestDto(
        newPassword: newPassword,
        sessionToken: _preAuthSession.require(),
      ),
    );
    // The forgot-password flow ends here — the user logs in again next.
    _preAuthSession.clear();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _remoteDataSource.changePassword(
      ChangePasswordRequestDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }

  @override
  Future<void> logout() async {
    // The data source throws on failure; tokens are only cleared on success.
    await _remoteDataSource.logout();
    await _secureStorage.clearTokens();
  }

  static const _defaultLanguage = 'en';

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getAccessToken();
    return token != null;
  }
}
