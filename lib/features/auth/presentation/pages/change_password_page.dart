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
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../profile/domain/use_cases/change_password_use_case.dart';
import '../view_model/change_password_state.dart';
import '../view_model/change_password_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/password_requirement_hint.dart';

/// Change-password screen, reached from the Profile tab. Verifies the current
/// password and sets a new one (same rules as registration). On success it
/// shows a snackbar and returns to Profile.
class ChangePasswordPage extends StatelessWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ChangePasswordViewModel>(
      create: (_) => ChangePasswordViewModel(
        changePasswordUseCase: getIt<ChangePasswordUseCase>(),
      ),
      child: const _ChangePasswordView(),
    );
  }
}

class _ChangePasswordView extends StatelessWidget {
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      appBar: const AppTopBar(),
      body: SafeArea(
        child: ViewModelConsumer<ChangePasswordViewModel, ChangePasswordState>(
          listenWhen: (p, c) =>
              p.errorMessage != c.errorMessage ||
              (!p.isSuccess && c.isSuccess),
          listener: (context, state) {
            final message = state.errorMessage;
            if (message != null) {
              BennySnackBar.show(
                message: message,
                type: BaseSnackBarType.error,
              );
            }
            if (state.isSuccess) {
              BennySnackBar.show(message: 'auth.change.success'.tr());
              if (context.canPop()) {
                context.pop();
              }
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    titleKey: 'auth.change.title',
                    captionKey: 'auth.change.caption',
                  ),
                  SizedBox(height: theme.spacing.spacing24),
                  AuthCard(child: _FormContent(state: state)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent({required this.state});

  final ChangePasswordState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<ChangePasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthPasswordField(
          hintText: 'auth.change.current_password'.tr(),
          onTextChanged: viewModel.onCurrentPasswordChanged,
        ),
        SizedBox(height: theme.spacing.spacing12),
        AuthPasswordField(
          hintText: 'auth.change.new_password'.tr(),
          onTextChanged: viewModel.onNewPasswordChanged,
          errorText: state.hasNewSameAsCurrent
              ? 'auth.change.new_same_as_current'.tr()
              : null,
        ),
        SizedBox(height: theme.spacing.spacing12),
        AuthPasswordField(
          hintText: 'auth.change.confirm_password'.tr(),
          onTextChanged: viewModel.onConfirmPasswordChanged,
          errorText: state.hasConfirmMismatch
              ? 'auth.register.password_mismatch'.tr()
              : null,
        ),
        SizedBox(height: theme.spacing.spacing8),
        PasswordRequirementHint(
          strength: state.strength,
          isPasswordEmpty: state.newPassword.isEmpty,
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.change.submit'.tr(),
          isWrapContent: false,
          onPressed: (state.canSubmit && !state.isLoading)
              ? viewModel.changePassword
              : null,
          widget: state.isLoading ? const BennySpinner() : null,
        ),
        SizedBox(height: theme.spacing.spacing16),
      ],
    );
  }
}
