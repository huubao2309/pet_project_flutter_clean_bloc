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
  /// [scenario] and [latency] are injectable so tests can pick any mock JSON and
  /// run instantly; the defaults preserve the dev behaviour wired in DI.
  const AppUpdateMockDataSource({
    String scenario = MockAssets.appUpdateNone,
    Duration latency = const Duration(milliseconds: 500),
  })  : _scenario = scenario,
        _latency = latency;

  final String _scenario;
  final Duration _latency;

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
