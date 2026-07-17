import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/core/network/http_client.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/forgot_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/login_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/reset_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/register_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/sign_up_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/request/verify_otp_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/login_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/otp_challenge_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/register_password_data_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/auth/response/verify_otp_data_dto.dart';
import 'auth_block_verdict.dart';
import 'auth_remote_data_source.dart';

/// Real [AuthRemoteDataSource] talking to the backend over an [HttpClient].
class AuthApiDataSource implements AuthRemoteDataSource {
  const AuthApiDataSource({required HttpClient httpClient})
      : _httpClient = httpClient;

  final HttpClient _httpClient;

  static const _login = '/auth/login';
  static const _logout = '/auth/logout';
  static const _signUp = '/auth/signup';
  static const _forgotPassword = '/auth/forgot-password';
  static const _resetPassword = '/auth/reset-password';
  static const _verifyOTP = '/auth/verify-otp';
  static const _registerPassword = '/auth/register-password';

  @override
  Future<LoginDataDto> login(LoginRequestDto request) async {
    try {
      final response = await _httpClient.post<LoginDataDto>(
        _login,
        data: request.toJson(),
        fromJson: (json) => LoginDataDto.fromJson(json as Map<String, dynamic>),
      );

      if (!response.success || response.data == null) {
        throw ServerException(
          code: AppErrorCode.loginFailed,
          message: response.message,
        );
      }

      return response.data!;
    } on ServerException catch (e) {
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
      final response = await _httpClient.post<OtpChallengeDto>(
        _signUp,
        data: request.toJson(),
        fromJson: (json) =>
            OtpChallengeDto.fromJson(json as Map<String, dynamic>),
      );

      if (!response.success) {
        throw ServerException(
          code: AppErrorCode.signupFailed,
          message: response.message,
        );
      }
      return response.data ?? const OtpChallengeDto();
    } on ServerException catch (e) {
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

  /// The nested `data.user_message` from an envelope, or null when absent (the
  /// presentation layer then falls back to the exception's code).
  String? _userMessageOf(Object? responseData) {
    final data = responseData is Map ? responseData['data'] : null;
    final userMessage = data is Map ? data['user_message'] as String? : null;
    return userMessage;
  }

  @override
  Future<OtpChallengeDto> forgotPassword(
    ForgotPasswordRequestDto request,
  ) async {
    final response = await _httpClient.post<OtpChallengeDto>(
      _forgotPassword,
      data: request.toJson(),
      fromJson: (json) =>
          OtpChallengeDto.fromJson(json as Map<String, dynamic>),
    );
    if (!response.success || response.data == null) {
      throw ServerException(
        code: AppErrorCode.forgotFailed,
        message: response.message,
      );
    }
    return response.data!;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestDto request) async {
    final response = await _httpClient.post<void>(
      _resetPassword,
      data: request.toJson(),
    );
    if (!response.success) {
      throw ServerException(
        code: AppErrorCode.resetFailed,
        message: response.message,
      );
    }
  }

  @override
  Future<VerifyOtpDataDto> verifyOtp(VerifyOtpRequestDto request) async {
    final response = await _httpClient.post<VerifyOtpDataDto>(
      _verifyOTP,
      data: request.toJson(),
      fromJson: (json) =>
          VerifyOtpDataDto.fromJson(json as Map<String, dynamic>),
    );
    if (!response.success || response.data == null) {
      throw ServerException(
        code: AppErrorCode.verifyOtpFailed,
        message: response.message,
      );
    }
    return response.data!;
  }

  @override
  Future<RegisterPasswordDataDto> registerPassword(
    RegisterPasswordRequestDto request,
  ) async {
    final response = await _httpClient.post<RegisterPasswordDataDto>(
      _registerPassword,
      data: request.toJson(),
      fromJson: (json) =>
          RegisterPasswordDataDto.fromJson(json as Map<String, dynamic>),
    );
    if (!response.success || response.data == null) {
      throw ServerException(
        code: AppErrorCode.registerPasswordFailed,
        message: response.message,
      );
    }
    return response.data!;
  }

  @override
  Future<void> logout() async {
    final response = await _httpClient.post<void>(_logout);

    if (!response.success) {
      throw ServerException(
        code: AppErrorCode.logoutFailed,
        message: response.message,
      );
    }
  }
}
