import 'package:pet_project_flutter_clean_bloc/data/models/app_update/app_update_config_dto.dart';

/// Fetches the app's update policy from the backend.
abstract class AppUpdateRemoteDataSource {
  /// The update config, or null when the backend reports no update available.
  Future<AppUpdateConfigDto?> fetchConfig();
}
