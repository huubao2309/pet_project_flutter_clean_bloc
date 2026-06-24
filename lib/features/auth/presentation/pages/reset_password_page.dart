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
import '../../../../core/router/app_routes.dart';
import '../../domain/use_cases/reset_password_use_case.dart';
import '../view_model/reset_password_state.dart';
import '../view_model/reset_password_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/password_requirement_hint.dart';

/// Final step of the forgot-password flow (after OTP): the user sets a new
/// password. On success the backend ends the session (`challenge_type:
/// "verify_login"`), so we return to Login — carrying the phone for autofill —
/// where the user must sign in with the new password.
class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({this.phone, super.key});

  /// Phone carried through the flow, used to autofill the Login screen after.
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ResetPasswordViewModel>(
      create: (_) => ResetPasswordViewModel(
        resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      ),
      child: _ResetPasswordView(phone: phone),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView({this.phone});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      appBar: const AppTopBar(),
      body: SafeArea(
        child: ViewModelConsumer<ResetPasswordViewModel, ResetPasswordState>(
          listenWhen: (p, c) =>
              p.errorMessage != c.errorMessage ||
              (!p.isResetSuccess && c.isResetSuccess),
          listener: (context, state) {
            final message = state.errorMessage;
            if (message != null) {
              BennySnackBar.show(
                message: message,
                type: BaseSnackBarType.error,
              );
            }
            if (state.isResetSuccess) {
              // Password reset → session ended; return to Login with the phone
              // pre-filled so the user signs in with the new password.
              BennySnackBar.show(message: 'auth.reset.success'.tr());
              context.go(
                Uri(
                  path: AppRoutes.login,
                  queryParameters: {'phone': phone ?? ''},
                ).toString(),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    titleKey: 'auth.reset.title',
                    captionKey: 'auth.reset.caption',
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

  final ResetPasswordState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<ResetPasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthPasswordField(
          hintText: 'auth.reset.new_password'.tr(),
          onTextChanged: viewModel.onPasswordChanged,
        ),
        SizedBox(height: theme.spacing.spacing12),
        AuthPasswordField(
          hintText: 'auth.register.confirm_password'.tr(),
          onTextChanged: viewModel.onConfirmPasswordChanged,
          errorText: state.hasConfirmMismatch
              ? 'auth.register.password_mismatch'.tr()
              : null,
        ),
        // Password-rule hint sits below both fields (per the design system).
        SizedBox(height: theme.spacing.spacing8),
        PasswordRequirementHint(
          strength: state.strength,
          isPasswordEmpty: state.password.isEmpty,
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.reset.submit'.tr(),
          isWrapContent: false,
          onPressed: (state.canSubmit && !state.isLoading)
              ? viewModel.resetPassword
              : null,
          widget: state.isLoading ? const BennySpinner() : null,
        ),
      ],
    );
  }
}
