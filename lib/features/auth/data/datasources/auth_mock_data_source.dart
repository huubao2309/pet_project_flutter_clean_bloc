import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../../../../core/error/app_exception.dart';
import '../models/request/forgot_password_request_dto.dart';
import '../models/request/login_request_dto.dart';
import '../models/request/reset_password_request_dto.dart';
import '../models/request/sign_up_request_dto.dart';
import '../models/response/login_data_dto.dart';
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
  const AuthMockDataSource();

  // ── 🔧 Scenario switches (one line each) ─────────────────────────────────
  static const _loginScenario = MockAssets.loginAccountIsDeleted;
  static const _signUpScenario = MockAssets.signupIsBlocked;
  static const _logoutScenario = MockAssets.logoutSuccess;

  static const _latency = Duration(seconds: 1);

  @override
  Future<LoginDataDto> login(LoginRequestDto request) async {
    final json = await _read(_loginScenario);
    // Login-only hard stops (account blocked): the verdict maps to a
    // BlockReason. These are meaningful for login only, so they stay here
    // rather than in the shared _ensureSuccess.
    final blockReason = blockReasonFromVerdict(json['verdict'] as String?);
    if (blockReason != null) {
      throw AccountBlockedException(blockReason, _messageOf(json));
    }
    _ensureSuccess(json);
    return LoginDataDto.fromJson(json['data'] as Map<String, dynamic>);
  }

  @override
  Future<bool> signUp(SignUpRequestDto request) async {
    final json = await _read(_signUpScenario);
    // Sign-up-only hard stop: the phone is blocked from registering. Like the
    // login blocks, this verdict is meaningful for sign-up only, so it stays
    // here rather than in the shared _ensureSuccess.
    if (isPhoneBlockedVerdict(json['verdict'] as String?)) {
      throw PhoneBlockedException(_messageOf(json));
    }
    _ensureSuccess(json);
    return true;
  }

  @override
  Future<void> forgotPassword(ForgotPasswordRequestDto request) async {
    await Future<void>.delayed(_latency);
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestDto request) async {
    await Future<void>.delayed(_latency);
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
    throw ServerException(message: _messageOf(json));
  }

  /// The user-facing message for a response: the nested `user_message`, then
  /// the top-level `message`, then a generic fallback.
  String _messageOf(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return (data?['user_message'] as String?) ??
        (json['message'] as String?) ??
        'errors.unknown'.tr();
  }
}
