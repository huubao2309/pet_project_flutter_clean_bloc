import '../models/user_profile_dto.dart';

/// Remote data source contract for the profile feature.
///
/// Returns DTOs and throws [AppException]s on failure. The repository depends
/// on this abstraction, so swapping the real API for fake data is a single DI
/// line — see [ProfileApiDataSource] (real) and [ProfileMockDataSource] (fake).
abstract class ProfileRemoteDataSource {
  Future<UserProfileDto> getProfile();
}
