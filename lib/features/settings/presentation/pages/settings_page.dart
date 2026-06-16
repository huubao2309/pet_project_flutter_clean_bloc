import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/loading/spinner/benny_spinner.dart';
import 'package:benny_style/snackbar/base_snackbar_type.dart';
import 'package:benny_style/snackbar/benny_snackbar.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/language_switcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';

/// Settings tab — language selection and logout. Reuses [AuthViewModel] for
/// the logout flow.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AuthViewModel>(
      create: (_) => getIt<AuthViewModel>(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.neutral25,
      appBar: AppBar(
        backgroundColor: theme.colors.neutral25,
        elevation: 0,
        title: Text('settings.title'.tr()),
        actions: const [LanguageSwitcher()],
      ),
      body: ViewModelConsumer<AuthViewModel, AuthState>(
        listenWhen: (_, c) => c is AuthUnauthenticated || c is AuthFailure,
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            getIt<AppRouter>().setLoggedIn(value: false);
            // BennySnackBar defaults to the green success style.
            BennySnackBar.show(message: 'settings.logout_success'.tr());
            context.go(AppRoutes.welcome);
          } else if (state is AuthFailure) {
            BennySnackBar.show(
              message: state.message,
              type: BaseSnackBarType.error,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(theme.spacing.spacing16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  BennyPrimaryButton(
                    title: 'settings.logout'.tr(),
                    isWrapContent: false,
                    onPressed: isLoading
                        ? null
                        : () => context.viewModel<AuthViewModel>().logout(),
                    widget: isLoading ? const BennySpinner() : null,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
