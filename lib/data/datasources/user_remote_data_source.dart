import 'package:pet_project_flutter_clean_bloc/data/models/profile/request/change_password_request_dto.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/user_profile_dto.dart';

/// Remote data source contract for the current user's account (`/user/*`).
///
/// Returns DTOs and throws [AppException]s on failure. The repository depends
/// on this abstraction, so swapping the real API for fake data is a single DI
/// line — see [UserApiDataSource] (real) and [UserMockDataSource] (fake).
abstract class UserRemoteDataSource {
  Future<UserProfileDto> getProfile();

  /// Changes the password for the logged-in user (verifies the current one).
  Future<void> changePassword(ChangePasswordRequestDto request);
}
