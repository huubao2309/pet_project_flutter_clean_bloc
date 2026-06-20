import '../../../../core/use_case/use_case.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Fetches the current user's profile (called when the main screen opens).
class GetProfileUseCase implements UseCase<UserProfile, NoParams> {
  const GetProfileUseCase({required this.profileRepository});

  final ProfileRepository profileRepository;

  @override
  Future<UserProfile> execute(NoParams params) =>
      profileRepository.getProfile();
}
