import 'package:benny_style/benny_locator.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../domain/entities/app_update_info.dart';
import '../view_model/app_update_state.dart';
import '../view_model/app_update_view_model.dart';
import 'app_update_dialog.dart';

/// Wraps the app and, once per launch, checks for a new version and shows the
/// right prompt over whatever screen is visible:
///  • forced   → a non-dismissible dialog (must update to continue),
///  • optional → a dismissible dialog shown at most once per version.
///
/// Placed above the router (see `main.dart`) so the prompt is independent of
/// the current route; dialogs are shown through the shared benny navigator.
/// Per Clean Architecture, this View only reacts to [AppUpdateViewModel] state.
class AppUpdateGate extends StatelessWidget {
  const AppUpdateGate({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AppUpdateViewModel>(
      create: (_) => getIt<AppUpdateViewModel>()..check(),
      child: ViewModelListener<AppUpdateViewModel, AppUpdateState>(
        listenWhen: (previous, current) =>
            current is AppUpdateForced || current is AppUpdateOptional,
        listener: (context, state) {
          final viewModel = context.viewModel<AppUpdateViewModel>();
          switch (state) {
            case AppUpdateForced(:final info):
              _showForced(viewModel, info);
            case AppUpdateOptional(:final info):
              _showOptional(viewModel, info);
            case AppUpdateInitial():
            case AppUpdateNotRequired():
              break;
          }
        },
        child: child,
      ),
    );
  }

  /// Non-dismissible: no barrier tap, no back button. The only button routes to
  /// the store; the dialog stays until the app is updated and relaunched.
  void _showForced(AppUpdateViewModel viewModel, AppUpdateInfo info) {
    final context = bennyNavigatorKey.currentContext;
    if (context == null) {
      return;
    }
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: AppUpdateDialog.forced(
          message: info.message,
          onUpdate: () => viewModel.openStore(info.storeUrl),
        ),
      ),
    );
  }

  /// Dismissible and shown at most once per version: the dismissal is recorded
  /// on close (button or barrier) so it won't nag again until a newer version
  /// ships; routes to the store if the user chose to update.
  Future<void> _showOptional(
    AppUpdateViewModel viewModel,
    AppUpdateInfo info,
  ) async {
    final context = bennyNavigatorKey.currentContext;
    if (context == null) {
      return;
    }
    final update = await showDialog<bool>(
      context: context,
      builder: (_) => AppUpdateDialog.optional(message: info.message),
    );
    await viewModel.dismissOptional(info.latestVersion);
    if (update == true) {
      await viewModel.openStore(info.storeUrl);
    }
  }
}
