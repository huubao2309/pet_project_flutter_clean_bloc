import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/app_error_localizer.dart';
import '../../../../core/presentation/view_model.dart';
import '../../../../core/use_case/use_case.dart';
import '../../domain/use_cases/get_profile_use_case.dart';
import 'profile_state.dart';

/// View model (MVVM) for the Profile tab. Loads the current user's profile so
/// the tab can display their info. [loadProfile] is triggered when the main
/// screen opens (see `MainPage`).
class ProfileViewModel extends ViewModel<ProfileState> {
  ProfileViewModel({required GetProfileUseCase getProfileUseCase})
      : _getProfileUseCase = getProfileUseCase,
        super(const ProfileInitial());

  final GetProfileUseCase _getProfileUseCase;

  Future<void> loadProfile() async {
    // Avoid refetching if a load is already in flight or has succeeded.
    if (currentState is ProfileLoading || currentState is ProfileLoaded) {
      return;
    }

    setState(const ProfileLoading());

    try {
      final profile = await _getProfileUseCase.execute(const NoParams());
      setState(ProfileLoaded(profile));
    } on AppException catch (e) {
      setState(ProfileError(AppErrorLocalizer.localize(e)));
    }
  }

  /// Forces a refetch (e.g. pull-to-refresh), ignoring the cached state.
  Future<void> refresh() async {
    setState(const ProfileInitial());
    await loadProfile();
  }
}
