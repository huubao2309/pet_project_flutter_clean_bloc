import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/loading/spinner/benny_spinner.dart';
import 'package:benny_style/messages/base_message_type.dart';
import 'package:benny_style/messages/snqd_message.dart';
import 'package:benny_style/snackbar/base_snackbar_type.dart';
import 'package:benny_style/snackbar/benny_snackbar.dart';
import 'package:benny_style/textfields/benny_textfield.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/forgot_password_state.dart';
import '../view_model/forgot_password_view_model.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ForgotPasswordViewModel>(
      create: (_) => getIt<ForgotPasswordViewModel>(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.neutral25,
      appBar: AppBar(
        backgroundColor: theme.colors.neutral25,
        elevation: 0,
        leading: BackButton(onPressed: () => context.go(AppRoutes.login)),
      ),
      body: SafeArea(
        child: ViewModelConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
          listenWhen: (p, c) => p.errorMessage != c.errorMessage,
          listener: (context, state) {
            final message = state.errorMessage;
            if (message != null) {
              BennySnackBar.show(
                message: message,
                type: BaseSnackBarType.error,
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'auth.forgot.title'.tr(),
                    style: theme.textStyle.heading
                        .copyWith(color: theme.colors.neutral900),
                  ),
                  Text(
                    'auth.forgot.caption'.tr(),
                    style: theme.textStyle.paragraphDefault
                        .copyWith(color: theme.colors.neutral700),
                  ),
                  SizedBox(height: theme.spacing.spacing40),
                  if (state.isEmailSent)
                    _SentContent(state: state)
                  else
                    _FormContent(state: state),
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

  final ForgotPasswordState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<ForgotPasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BennyTextField<String>(
          hintText: 'auth.forgot.email'.tr(),
          keyboardType: TextInputType.emailAddress,
          onTextChanged: viewModel.onEmailChanged,
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.forgot.send'.tr(),
          isWrapContent: false,
          onPressed: (state.canSubmit && !state.isLoading)
              ? viewModel.forgotPassword
              : null,
          widget: state.isLoading ? const BennySpinner() : null,
        ),
      ],
    );
  }
}

class _SentContent extends StatelessWidget {
  const _SentContent({required this.state});

  final ForgotPasswordState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Column(
      children: [
        BennyMessage(
          type: BaseMessageType.success,
          title: 'auth.forgot.sent'.tr(),
          message: 'auth.forgot.message'
              .tr(namedArgs: {'user_email': state.email.trim()}),
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennySecondaryButton(
          title: 'auth.forgot.back'.tr(),
          isWrapContent: false,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
