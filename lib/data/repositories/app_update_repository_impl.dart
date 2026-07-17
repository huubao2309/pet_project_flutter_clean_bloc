import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:pet_project_flutter_clean_bloc/core/storage/local_storage/local_storage.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/entities/app_update_config.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/domain/repositories/app_update_repository.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/app_update_remote_data_source.dart';

/// The single [AppUpdateRepository] implementation, backed by an
/// [AppUpdateRemoteDataSource] (real API or fake mock — chosen in DI),
/// [PackageInfo] for the running version, [LocalStorage] for the dismissal
/// flag, and `url_launcher` to open the store.
class AppUpdateRepositoryImpl implements AppUpdateRepository {
  const AppUpdateRepositoryImpl({
    required AppUpdateRemoteDataSource remoteDataSource,
    required LocalStorage localStorage,
  })  : _remoteDataSource = remoteDataSource,
        _localStorage = localStorage;

  final AppUpdateRemoteDataSource _remoteDataSource;
  final LocalStorage _localStorage;

  @override
  Future<AppUpdateConfig?> fetchConfig() async {
    final dto = await _remoteDataSource.fetchConfig();
    return dto?.toEntity();
  }

  @override
  Future<String> currentVersion() async {
    final info = await PackageInfo.fromPlatform();
    return info.version;
  }

  @override
  Future<String?> lastDismissedVersion() async =>
      _localStorage.getDismissedUpdateVersion();

  @override
  Future<void> saveDismissedVersion(String version) =>
      _localStorage.setDismissedUpdateVersion(value: version);

  @override
  Future<void> openStore(String url) async {
    if (url.isEmpty) {
      return;
    }
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }
}
