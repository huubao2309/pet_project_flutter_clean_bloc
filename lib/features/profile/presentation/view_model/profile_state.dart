import '../../domain/entities/user_profile.dart';

/// Immutable UI state for the Profile tab. Library-agnostic (no Bloc/GetX
/// types) so it survives a state-management migration unchanged.
sealed class ProfileState {
  const ProfileState();
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);
  final UserProfile profile;
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;
}
