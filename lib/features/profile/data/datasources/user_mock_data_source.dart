import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../../../../core/error/app_exception.dart';
import '../models/request/change_password_request_dto.dart';
import '../models/user_profile_dto.dart';
import 'user_remote_data_source.dart';

/// Fake [UserRemoteDataSource] that serves the JSON files in
/// `assets/mock/user_mock/`.
///
/// Mirrors the real API contract: it parses the `verdict` field and either
/// returns the DTO (success) or throws a [ServerException] (failure), exactly
/// like [UserApiDataSource]. Swap to the real backend in
/// core/di/injection.dart (one line).
class UserMockDataSource implements UserRemoteDataSource {
  const UserMockDataSource();

  // ── 🔧 Scenario switches (one line each) ─────────────────────────────────
  static const _profileScenario = MockAssets.profileSuccess;
  static const _changePasswordScenario = MockAssets.changePasswordSuccess;
  static const _latency = Duration(milliseconds: 500);

  @override
  Future<UserProfileDto> getProfile() async {
    final json = await _read(_profileScenario);
    final data = _ensureSuccess(json);
    return UserProfileDto.fromJson(data);
  }

  @override
  Future<void> changePassword(ChangePasswordRequestDto request) async {
    final json = await _read(_changePasswordScenario);
    _ensureSuccess(json);
  }

  /// Loads + decodes a mock JSON file, simulating network latency.
  Future<Map<String, dynamic>> _read(String asset) async {
    await Future<void>.delayed(_latency);
    final raw = await rootBundle.loadString(asset);
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  /// Throws a [ServerException] unless `verdict == "success"`; otherwise returns
  /// the `data` object.
  Map<String, dynamic> _ensureSuccess(Map<String, dynamic> json) {
    if (json['verdict'] != 'success') {
      throw ServerException(
        message: (json['message'] as String?) ?? 'errors.unknown'.tr(),
      );
    }
    return (json['data'] as Map<String, dynamic>?) ?? const {};
  }
}
