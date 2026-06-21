import '../entities/user_profile.dart';

/// Profile domain contract (a "port"). The data layer provides the
/// implementation; use cases depend on this abstraction only.
abstract class ProfileRepository {
  /// Fetches the current user's profile from the backend.
  Future<UserProfile> getProfile();

  /// Changes the password for the logged-in user. The backend verifies
  /// [currentPassword] before applying [newPassword].
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}
