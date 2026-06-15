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
import '../../domain/use_cases/reset_password_use_case.dart';
import '../view_model/reset_password_state.dart';
import '../view_model/reset_password_view_model.dart';
import '../widgets/validate_icon_widget.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({this.token, super.key});

  /// Reset token from the email deep link (e.g. `/reset-password?token=...`).
  final String? token;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ResetPasswordViewModel>(
      create: (_) => ResetPasswordViewModel(
        resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
        token: token ?? '',
      ),
      child: const _ResetPasswordView(),
    );
  }
}

class _ResetPasswordView extends StatelessWidget {
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.neutral25,
      body: SafeArea(
        child: ViewModelConsumer<ResetPasswordViewModel, ResetPasswordState>(
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
                    'auth.reset.title'.tr(),
                    style: theme.textStyle.heading
                        .copyWith(color: theme.colors.neutral900),
                  ),
                  Text(
                    'auth.reset.caption'.tr(),
                    style: theme.textStyle.paragraphDefault
                        .copyWith(color: theme.colors.neutral700),
                  ),
                  SizedBox(height: theme.spacing.spacing40),
                  if (state.isResetSuccess)
                    _SuccessContent(theme: theme)
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

  final ResetPasswordState state;

  ValidIconState _ruleState(bool passed) {
    if (state.password.isEmpty) {
      return ValidIconState.unknown;
    }
    return passed ? ValidIconState.valid : ValidIconState.invalid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<ResetPasswordViewModel>();
    final strength = state.strength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BennyTextField<String>(
          hintText: 'auth.reset.new_password'.tr(),
          obscureText: true,
          onTextChanged: viewModel.onPasswordChanged,
        ),
        SizedBox(height: theme.spacing.spacing12),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: theme.spacing.spacing16,
            vertical: theme.spacing.spacing12,
          ),
          decoration: BoxDecoration(
            color: theme.colors.neutral50,
            border: Border.all(color: theme.colors.neutral100),
            borderRadius:
                BorderRadius.circular(theme.borderRadius.borderRadius8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'auth.register.password_strength'.tr(),
                style: theme.textStyle.paragraphDefault
                    .copyWith(color: theme.colors.neutral900),
              ),
              SizedBox(height: theme.spacing.spacing8),
              ValidateIconWidget(
                state: _ruleState(strength.hasMinLength),
                title: 'auth.register.password_length'.tr(),
              ),
              SizedBox(height: theme.spacing.spacing8),
              ValidateIconWidget(
                state: _ruleState(strength.hasSpecialChar),
                title: 'auth.register.password_special'.tr(),
              ),
              SizedBox(height: theme.spacing.spacing8),
              ValidateIconWidget(
                state: _ruleState(strength.hasNumber),
                title: 'auth.register.password_number'.tr(),
              ),
              SizedBox(height: theme.spacing.spacing8),
              ValidateIconWidget(
                state: _ruleState(strength.hasCapital),
                title: 'auth.register.password_capital'.tr(),
              ),
            ],
          ),
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

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BennyMessage(
          type: BaseMessageType.success,
          title: 'auth.reset.success'.tr(),
          message: 'auth.reset.success_message'.tr(),
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennySecondaryButton(
          title: 'auth.reset.login_go'.tr(),
          isWrapContent: false,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
