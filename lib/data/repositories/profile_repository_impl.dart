import 'package:pet_project_flutter_clean_bloc/features/profile/domain/entities/user_profile.dart';
import 'package:pet_project_flutter_clean_bloc/features/profile/domain/repositories/profile_repository.dart';
import 'package:pet_project_flutter_clean_bloc/data/datasources/user_remote_data_source.dart';
import 'package:pet_project_flutter_clean_bloc/data/models/profile/request/change_password_request_dto.dart';

/// The single [ProfileRepository] implementation, backed by a
/// [UserRemoteDataSource] (real API or fake mock — chosen in DI). Maps the
/// response DTO to a domain entity and plain domain values to request DTOs.
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({required UserRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final UserRemoteDataSource _remoteDataSource;

  @override
  Future<UserProfile> getProfile() async {
    final dto = await _remoteDataSource.getProfile();
    return dto.toEntity();
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _remoteDataSource.changePassword(
      ChangePasswordRequestDto(
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }
}
