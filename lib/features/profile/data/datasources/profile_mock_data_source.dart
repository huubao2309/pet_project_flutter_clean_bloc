import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../../../../core/error/app_exception.dart';
import '../models/user_profile_dto.dart';
import 'profile_remote_data_source.dart';

/// Fake [ProfileRemoteDataSource] that serves the JSON files in
/// `assets/mock/profile_mock/`.
///
/// Mirrors the real API contract: it parses the `verdict` field and either
/// returns the DTO (success) or throws a [ServerException] (failure), exactly
/// like [ProfileApiDataSource]. Swap to the real backend in
/// core/di/injection.dart (one line).
class ProfileMockDataSource implements ProfileRemoteDataSource {
  const ProfileMockDataSource();

  // ── 🔧 Scenario switch (one line) ────────────────────────────────────────
  static const _scenario = MockAssets.profileSuccess;
  static const _latency = Duration(milliseconds: 500);

  @override
  Future<UserProfileDto> getProfile() async {
    await Future<void>.delayed(_latency);
    final raw = await rootBundle.loadString(_scenario);
    final json = jsonDecode(raw) as Map<String, dynamic>;

    if (json['verdict'] != 'success') {
      throw ServerException(
        message: (json['message'] as String?) ?? 'errors.unknown'.tr(),
      );
    }

    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw ServerException(message: 'errors.unknown'.tr());
    }
    return UserProfileDto.fromJson(data);
  }
}
