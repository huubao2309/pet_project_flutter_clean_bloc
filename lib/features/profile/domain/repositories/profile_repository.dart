import '../entities/user_profile.dart';

/// Profile domain contract (a "port"). The data layer provides the
/// implementation; use cases depend on this abstraction only.
abstract class ProfileRepository {
  /// Fetches the current user's profile from the backend.
  Future<UserProfile> getProfile();
}
