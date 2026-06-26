import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../../../../core/error/app_error_code.dart';
import '../../../../core/error/app_exception.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/register_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../models/request/verify_otp_request_dto.dart';
import '../models/response/login_data_dto.dart';
import '../models/response/otp_challenge_dto.dart';
import '../models/response/register_password_data_dto.dart';
import '../models/response/verify_otp_data_dto.dart';
import 'auth_block_verdict.dart';
import 'auth_remote_data_source.dart';

/// Fake [AuthRemoteDataSource] that serves the JSON files in `assets/mock/`.
///
/// It mimics the real API contract: it parses the `verdict` field and either
/// returns the DTO (success) or throws a [ServerException] (failure), exactly
/// like [AuthApiDataSource]. Because both implement the same interface, the
/// repository / use cases / UI are identical for real and fake data.
///
/// ── How to switch fake data (edit ONE line) ─────────────────────────────
///  - To test a failing scenario, point the scenario constant below at the
///    `*_failed.json` file (e.g. `_loginScenario = MockAssets.loginFailed`).
///  - To go back to the real backend, swap this data source for
///    [AuthApiDataSource] in core/di/injection.dart (also one line).
class AuthMockDataSource implements AuthRemoteDataSource {
  /// Per-endpoint scenarios + [latency] are injectable so tests can drive any
  /// mock JSON (success / failure / blocked) and run instantly. The defaults
  /// preserve the dev behaviour wired in DI — switching a scenario for manual
  /// testing is still a one-line change to the default here.
  const AuthMockDataSource({
    String loginScenario = MockAssets.loginSuccess,
    String signUpScenario = MockAssets.signupSuccess,
    String logoutScenario = MockAssets.logoutSuccess,
    String verifyOtpScenario = MockAssets.verifyOtpForgotSuccess,
    String registerPasswordScenario = MockAssets.registerPasswordSuccess,
    String forgotPasswordScenario = MockAssets.forgotPasswordSuccess,
    String resetPasswordScenario = MockAssets.resetPasswordSuccess,
    Duration latency = const Duration(seconds: 1),
  })  : _loginScenario = loginScenario,
        _signUpScenario = signUpScenario,
        _logoutScenario = logoutScenario,
        _verifyOTPScenario = verifyOtpScenario,
        _registerPasswordScenario = registerPasswordScenario,
        _forgotPasswordScenario = forgotPasswordScenario,
        _resetPasswordScenario = resetPasswordScenario,
        _latency = latency;

  final String _loginScenario;
  final String _signUpScenario;
  final String _logoutScenario;
  final String _verifyOTPScenario;
  final String _registerPasswordScenario;
  final String _forgotPasswordScenario;
  final String _resetPasswordScenario;
  final Duration _latency;

  @override
  Future<LoginDataDto> login(LoginRequestDto request) async {
    final json = await _read(_loginScenario);
    final blockReason = blockReasonFromVerdict(json['verdict'] as String?);
    if (blockReason != null) {
      throw AccountBlockedException(blockReason, _messageOf(json));
    }
    _ensureSuccess(json);
    return LoginDataDto.fromJson(json['data'] as Map<String, dynamic>);
  }

  @override
  Future<OtpChallengeDto> signUp(SignUpRequestDto request) async {
    final json = await _read(_signUpScenario);
    if (isPhoneBlockedVerdict(json['verdict'] as String?)) {
      throw PhoneBlockedException(_messageOf(json));
    }
    _ensureSuccess(json);
    final data = json['data'] as Map<String, dynamic>?;
    return data == null ? const OtpChallengeDto() : OtpChallengeDto.fromJson(data);
  }

  @override
  Future<OtpChallengeDto> forgotPassword(ForgotPasswordRequestDto request) async {
    final json = await _read(_forgotPasswordScenario);
    _ensureSuccess(json);
    return OtpChallengeDto.fromJson(json['data'] as Map<String, dynamic>);
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestDto request) async {
    final json = await _read(_resetPasswordScenario);
    _ensureSuccess(json);
  }

  @override
  Future<VerifyOtpDataDto> verifyOtp(
    VerifyOtpRequestDto request,
  ) async {
    final json = await _read(_verifyOTPScenario);
    _ensureSuccess(json);
    return VerifyOtpDataDto.fromJson(json['data'] as Map<String, dynamic>);
  }

  @override
  Future<RegisterPasswordDataDto> registerPassword(
    RegisterPasswordRequestDto request,
  ) async {
    final json = await _read(_registerPasswordScenario);
    _ensureSuccess(json);
    return RegisterPasswordDataDto.fromJson(
      json['data'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> logout() async {
    final json = await _read(_logoutScenario);
    _ensureSuccess(json);
  }

  /// Loads + decodes a mock JSON file, simulating network latency.
  Future<Map<String, dynamic>> _read(String asset) async {
    await Future<void>.delayed(_latency);
    final raw = await rootBundle.loadString(asset);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Throws a [ServerException] on any non-success response, mirroring how the
  /// real API failures surface. Verdict-specific handling (e.g. the login-only
  /// `otp_limit_exceeded` lock) belongs in the calling method, not here.
  void _ensureSuccess(Map<String, dynamic> json) {
    if (json['verdict'] == 'success') {
      return;
    }
    throw ServerException(code: AppErrorCode.unknown, message: _messageOf(json));
  }

  /// The user-facing message for a response: the nested `user_message`, then the
  /// top-level `message`, or null (the presentation layer then localizes the
  /// exception's code).
  String? _messageOf(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return (data?['user_message'] as String?) ?? (json['message'] as String?);
  }
}
