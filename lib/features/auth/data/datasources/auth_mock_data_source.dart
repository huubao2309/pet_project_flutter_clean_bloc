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
  static const _loginScenario = MockAssets.loginSuccess; // ↔ loginFailed
  static const _logoutScenario = MockAssets.logoutSuccess; // ↔ logoutFailed

  static const _latency = Duration(seconds: 1);

  @override
  Future<LoginDataDto> login(LoginRequestDto request) async {
    final json = await _read(_loginScenario);
    _ensureSuccess(json);
    return LoginDataDto.fromJson(json['data'] as Map<String, dynamic>);
  }

  @override
  Future<bool> signUp(SignUpRequestDto request) async {
    await Future<void>.delayed(_latency);
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

  /// Throws a [ServerException] when the mock response is not a success,
  /// mirroring how the real API failures surface.
  void _ensureSuccess(Map<String, dynamic> json) {
    if (json['verdict'] == 'success') {
      return;
    }
    final data = json['data'] as Map<String, dynamic>?;
    final message = (data?['user_message'] as String?) ??
        (json['message'] as String?) ??
        'errors.unknown'.tr();
    throw ServerException(message: message);
  }
}
