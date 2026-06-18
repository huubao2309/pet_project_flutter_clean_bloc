import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../../core/constants/mock_assets.dart';
import '../models/app_update_config_dto.dart';
import 'app_update_remote_data_source.dart';

/// Fake [AppUpdateRemoteDataSource] serving the JSON files in
/// `assets/mock/app_update_mock/`.
///
/// ── 🔧 Switch scenario (edit ONE line) ──────────────────────────────────
///  - Force update : `MockAssets.appUpdateForce`
///  - Optional     : `MockAssets.appUpdateOptional`
///  - No update    : `MockAssets.appUpdateNone`
class AppUpdateMockDataSource implements AppUpdateRemoteDataSource {
  const AppUpdateMockDataSource();

  static const _scenario = MockAssets.appUpdateForce;
  static const _latency = Duration(milliseconds: 500);

  @override
  Future<AppUpdateConfigDto?> fetchConfig() async {
    await Future<void>.delayed(_latency);
    final raw = await rootBundle.loadString(_scenario);
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>?;
    if (data == null || data.isEmpty) {
      return null;
    }
    return AppUpdateConfigDto.fromJson(data);
  }
}
