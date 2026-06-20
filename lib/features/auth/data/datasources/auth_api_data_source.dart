import 'package:easy_localization/easy_localization.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/network/dio_client.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../models/response/login_data_dto.dart';
import '../models/response/otp_challenge_dto.dart';
import 'auth_block_verdict.dart';
import 'auth_remote_data_source.dart';

/// Real [AuthRemoteDataSource] talking to the backend over [DioClient].
class AuthApiDataSource implements AuthRemoteDataSource {
  const AuthApiDataSource({required DioClient dioClient})
      : _dioClient = dioClient;

  final DioClient _dioClient;

  static const _login = '/auth/login';
  static const _logout = '/auth/logout';
  static const _signUp = '/auth/signup';
  static const _forgotPassword = '/auth/forgot-password';
  static const _resetPassword = '/auth/reset-password';

  @override
  Future<LoginDataDto> login(LoginRequestDto request) async {
    try {
      final response = await _dioClient.post<LoginDataDto>(
        _login,
        data: request.toJson(),
        fromJson: (json) => LoginDataDto.fromJson(json as Map<String, dynamic>),
      );

      if (!response.success || response.data == null) {
        throw ServerException(
          message: response.message ?? 'errors.login_failed'.tr(),
        );
      }

      return response.data!;
    } on ServerException catch (e) {
      // Login-only hard stop: too many wrong OTP entries → account locked. The
      // backend reports verdict `otp_limit_exceeded` with HTTP 400, which the
      // (generic) DioClient surfaces as a ServerException carrying the raw
      // response body. Keeping the verdict check here — not in DioClient —
      // means it applies to login only.
      final blocked = _accountBlockedFrom(e.responseData);
      if (blocked != null) {
        throw blocked;
      }
      rethrow;
    }
  }

  /// Maps a backend account-block envelope (e.g. `otp_limit_exceeded`,
  /// `account_is_deleted`) to an [AccountBlockedException], or returns null when
  /// [responseData] is anything else (the caller then keeps the original error).
  AccountBlockedException? _accountBlockedFrom(Object? responseData) {
    if (responseData is! Map) {
      return null;
    }
    final reason = blockReasonFromVerdict(responseData['verdict'] as String?);
    if (reason == null) {
      return null;
    }
    return AccountBlockedException(reason, _userMessageOf(responseData));
  }

  @override
  Future<OtpChallengeDto> signUp(SignUpRequestDto request) async {
    try {
      final response = await _dioClient.post<OtpChallengeDto>(
        _signUp,
        data: request.toJson(),
        fromJson: (json) =>
            OtpChallengeDto.fromJson(json as Map<String, dynamic>),
      );

      if (!response.success) {
        throw ServerException(
          message: response.message ?? 'errors.signup_failed'.tr(),
        );
      }
      // No `data` (registration completed without a challenge) → empty DTO.
      return response.data ?? const OtpChallengeDto();
    } on ServerException catch (e) {
      // Sign-up-only hard stop: the phone is blocked (verdict `phone_is_blocked`,
      // HTTP 400). DioClient surfaces it as a ServerException carrying the raw
      // body; the verdict check stays here so it applies to sign-up only.
      if (_isPhoneBlocked(e.responseData)) {
        throw PhoneBlockedException(_userMessageOf(e.responseData));
      }
      rethrow;
    }
  }

  /// True when [responseData] is the backend's `phone_is_blocked` envelope.
  bool _isPhoneBlocked(Object? responseData) =>
      responseData is Map &&
      isPhoneBlockedVerdict(responseData['verdict'] as String?);

  /// The nested `data.user_message` from an envelope, or a generic fallback.
  String _userMessageOf(Object? responseData) {
    final data = responseData is Map ? responseData['data'] : null;
    final userMessage = data is Map ? data['user_message'] as String? : null;
    return userMessage ?? 'errors.unknown'.tr();
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequestDto request) async {
    final response = await _dioClient.post<void>(
      _forgotPassword,
      data: request.toJson(),
    );
    if (!response.success) {
      throw ServerException(
        message: response.message ?? 'errors.forgot_failed'.tr(),
      );
    }
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestDto request) async {
    final response = await _dioClient.post<void>(
      _resetPassword,
      data: request.toJson(),
    );
    if (!response.success) {
      throw ServerException(
        message: response.message ?? 'errors.reset_failed'.tr(),
      );
    }
  }

  @override
  Future<void> logout() async {
    final response = await _dioClient.post<void>(_logout);

    if (!response.success) {
      throw ServerException(message: response.message ?? 'errors.logout_failed'.tr());
    }
  }
}
