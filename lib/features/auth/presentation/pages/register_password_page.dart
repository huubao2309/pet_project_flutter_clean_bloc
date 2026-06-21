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
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../domain/use_cases/register_password_use_case.dart';
import '../view_model/register_password_state.dart';
import '../view_model/register_password_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/password_requirement_hint.dart';

/// Final step of the sign-up flow (after OTP): the user sets a password. On
/// success the account is created and signed in, landing on the main screen.
class RegisterPasswordPage extends StatelessWidget {
  const RegisterPasswordPage({required this.sessionToken, super.key});

  /// Session token from the verify-otp response, submitted with the password.
  final String sessionToken;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<RegisterPasswordViewModel>(
      create: (_) => RegisterPasswordViewModel(
        registerPasswordUseCase: getIt<RegisterPasswordUseCase>(),
        sessionToken: sessionToken,
      ),
      child: const _RegisterPasswordView(),
    );
  }
}

class _RegisterPasswordView extends StatelessWidget {
  const _RegisterPasswordView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppTopBar(backgroundColor: theme.colors.surfaceBackground),
      body: SafeArea(
        child: ViewModelConsumer<RegisterPasswordViewModel,
            RegisterPasswordState>(
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
              // Account created and signed in → grant the session and go Home.
              getIt<AppRouter>().setLoggedIn(value: true);
              context.go(AppRoutes.main);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    titleKey: 'auth.register_password.title',
                    captionKey: 'auth.register_password.caption',
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

  final RegisterPasswordState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<RegisterPasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AuthPasswordField(
          hintText: 'auth.register.password'.tr(),
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
        // Password-rule hint sits below both fields (see "Register · Mật khẩu"
        // in the design system).
        SizedBox(height: theme.spacing.spacing8),
        PasswordRequirementHint(
          strength: state.strength,
          isPasswordEmpty: state.password.isEmpty,
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.register.continue'.tr(),
          isWrapContent: false,
          onPressed:
              (state.canSubmit && !state.isLoading) ? viewModel.submit : null,
          widget: state.isLoading ? const BennySpinner() : null,
        ),
        SizedBox(height: theme.spacing.spacing16),
      ],
    );
  }
}
