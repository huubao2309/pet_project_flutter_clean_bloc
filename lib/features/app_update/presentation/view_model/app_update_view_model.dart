import '../../../../core/presentation/view_model.dart';
import '../../../../core/use_case/use_case.dart';
import '../../domain/entities/app_update_status.dart';
import '../../domain/use_cases/check_app_update_use_case.dart';
import '../../domain/use_cases/dismiss_optional_update_use_case.dart';
import '../../domain/use_cases/open_store_use_case.dart';
import 'app_update_state.dart';

/// View model for the app-update feature. The View ([AppUpdateGate]) calls
/// [check] once per launch and reacts to the resulting state by showing the
/// right dialog.
class AppUpdateViewModel extends ViewModel<AppUpdateState> {
  AppUpdateViewModel({
    required CheckAppUpdateUseCase checkUseCase,
    required DismissOptionalUpdateUseCase dismissUseCase,
    required OpenStoreUseCase openStoreUseCase,
  })  : _checkUseCase = checkUseCase,
        _dismissUseCase = dismissUseCase,
        _openStoreUseCase = openStoreUseCase,
        super(const AppUpdateInitial());

  final CheckAppUpdateUseCase _checkUseCase;
  final DismissOptionalUpdateUseCase _dismissUseCase;
  final OpenStoreUseCase _openStoreUseCase;

  Future<void> check() async {
    try {
      final status = await _checkUseCase.execute(const NoParams());
      switch (status) {
        case AppUpToDate():
          setState(const AppUpdateNotRequired());
        case AppOptionalUpdate(:final info):
          setState(AppUpdateOptional(info));
        case AppForcedUpdate(:final info):
          setState(AppUpdateForced(info));
      }
    } on Exception {
      // An update check must never block the app — fail open as "up to date".
      setState(const AppUpdateNotRequired());
    }
  }

  /// Remembers the dismissal so the optional prompt won't show again until a
  /// newer version ships, then clears the prompt state.
  Future<void> dismissOptional(String version) async {
    await _dismissUseCase.execute(version);
    setState(const AppUpdateNotRequired());
  }

  Future<void> openStore(String url) => _openStoreUseCase.execute(url);
}
