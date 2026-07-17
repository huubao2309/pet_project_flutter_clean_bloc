import 'dart:convert';

import 'package:flutter/services.dart';

import 'package:pet_project_flutter_clean_bloc/core/constants/mock_assets.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_error_code.dart';
import 'package:pet_project_flutter_clean_bloc/core/error/app_exception.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/request/change_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/user_profile_dto.dart';
import 'user_remote_data_source.dart';

/// Fake [UserRemoteDataSource] that serves the JSON files in
/// `assets/mock/user_mock/`.
///
/// Mirrors the real API contract: it parses the `verdict` field and either
/// returns the DTO (success) or throws a [ServerException] (failure), exactly
/// like [UserApiDataSource]. Swap to the real backend in
/// core/di/injection.dart (one line).
class UserMockDataSource implements UserRemoteDataSource {
  /// Scenarios + [latency] are injectable so tests can drive any mock JSON and
  /// run instantly; the defaults preserve the dev behaviour wired in DI.
  const UserMockDataSource({
    String profileScenario = MockAssets.profileSuccess,
    String changePasswordScenario = MockAssets.changePasswordSuccess,
    Duration latency = const Duration(milliseconds: 500),
  })  : _profileScenario = profileScenario,
        _changePasswordScenario = changePasswordScenario,
        _latency = latency;

  final String _profileScenario;
  final String _changePasswordScenario;
  final Duration _latency;

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
        code: AppErrorCode.unknown,
        message: json['message'] as String?,
      );
    }
    return (json['data'] as Map<String, dynamic>?) ?? const {};
  }
}
