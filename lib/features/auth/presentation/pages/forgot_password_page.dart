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
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/forgot_password_state.dart';
import '../view_model/forgot_password_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';

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
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppTopBar(backgroundColor: theme.colors.surfaceBackground),
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
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    titleKey: 'auth.forgot.title',
                    captionKey: 'auth.forgot.caption',
                  ),
                  SizedBox(height: theme.spacing.spacing24),
                  if (state.isSent)
                    _SentContent(state: state)
                  else
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
          hintText: 'auth.forgot.phone'.tr(),
          keyboardType: TextInputType.phone,
          onTextChanged: viewModel.onPhoneChanged,
          errorText: (state.phone.isNotEmpty && !state.isPhoneValid)
              ? 'auth.phone_invalid'.tr()
              : null,
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
              .tr(namedArgs: {'phone': state.phone.trim()}),
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.forgot.enter_code'.tr(),
          isWrapContent: false,
          onPressed: () => context.push(
            Uri(
              path: AppRoutes.otp,
              queryParameters: {'phone': state.phone.trim()},
            ).toString(),
          ),
        ),
        SizedBox(height: theme.spacing.spacing12),
        BennySecondaryButton(
          title: 'auth.forgot.back'.tr(),
          isWrapContent: false,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
