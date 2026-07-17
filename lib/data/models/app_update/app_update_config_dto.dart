import 'dart:io' show Platform;

import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_config.dart';

/// Maps the backend's `data` envelope for the version endpoint. Manual
/// `fromJson` (no codegen) keeps this self-contained.
///
/// Expected shape:
/// ```json
/// {
///   "latest_version": "2.5.0",
///   "min_required_version": "2.0.0",
///   "force_update": false,
///   "release_notes": "…",
///   "store_url": { "android": "https://…", "ios": "https://…" }
/// }
/// ```
class AppUpdateConfigDto {
  const AppUpdateConfigDto({
    required this.latestVersion,
    required this.minRequiredVersion,
    required this.forceUpdate,
    required this.androidUrl,
    required this.iosUrl,
    this.releaseNotes,
  });

  final String latestVersion;
  final String minRequiredVersion;
  final bool forceUpdate;
  final String androidUrl;
  final String iosUrl;
  final String? releaseNotes;

  factory AppUpdateConfigDto.fromJson(Map<String, dynamic> json) {
    final storeUrl = json['store_url'] as Map<String, dynamic>? ?? const {};
    return AppUpdateConfigDto(
      latestVersion: json['latest_version'] as String? ?? '0.0.0',
      minRequiredVersion: json['min_required_version'] as String? ?? '0.0.0',
      forceUpdate: json['force_update'] as bool? ?? false,
      androidUrl: storeUrl['android'] as String? ?? '',
      iosUrl: storeUrl['ios'] as String? ?? '',
      releaseNotes: json['release_notes'] as String?,
    );
  }

  /// Resolves the platform-specific store URL into the domain entity.
  AppUpdateConfig toEntity() => AppUpdateConfig(
        latestVersion: latestVersion,
        minRequiredVersion: minRequiredVersion,
        forceUpdate: forceUpdate,
        storeUrl: Platform.isIOS ? iosUrl : androidUrl,
        message: releaseNotes,
      );
}
