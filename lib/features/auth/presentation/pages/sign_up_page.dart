import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/loading/spinner/benny_spinner.dart';
import 'package:benny_style/messages/base_message_type.dart';
import 'package:benny_style/messages/snqd_message.dart';
import 'package:benny_style/selectors/checkbox/benny_check_box.dart';
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
import '../view_model/sign_up_state.dart';
import '../view_model/sign_up_view_model.dart';
import '../widgets/validate_icon_widget.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>(
      create: (_) => getIt<SignUpViewModel>(),
      child: const _SignUpView(),
    );
  }
}

class _SignUpView extends StatelessWidget {
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.neutral25,
      body: SafeArea(
        child: ViewModelConsumer<SignUpViewModel, SignUpState>(
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
                    'auth.register.title'.tr(),
                    style: theme.textStyle.heading
                        .copyWith(color: theme.colors.neutral900),
                  ),
                  Text(
                    'auth.register.caption'.tr(),
                    style: theme.textStyle.paragraphDefault
                        .copyWith(color: theme.colors.neutral700),
                  ),
                  SizedBox(height: theme.spacing.spacing40),
                  if (state.isSuccess)
                    _SuccessContent(state: state)
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

  final SignUpState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<SignUpViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        BennyTextField<String>(
          hintText: 'auth.register.email'.tr(),
          keyboardType: TextInputType.emailAddress,
          onTextChanged: viewModel.onEmailChanged,
        ),
        SizedBox(height: theme.spacing.spacing12),
        BennyTextField<String>(
          hintText: 'auth.register.password'.tr(),
          obscureText: true,
          onTextChanged: viewModel.onPasswordChanged,
        ),
        SizedBox(height: theme.spacing.spacing12),
        _PasswordChecklist(state: state),
        SizedBox(height: theme.spacing.spacing12),
        BennyCheckbox(
          enable: true,
          title: 'auth.register.updates_caption'.tr(),
          value: state.receiveUpdates,
          spacing: theme.spacing.spacing4,
          size: 24,
          onChange: (value) =>
              viewModel.onReceiveUpdatesChanged(value: value ?? false),
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.register.button'.tr(),
          isWrapContent: false,
          onPressed: state.canSubmit ? viewModel.signUp : null,
          widget: state.isLoading ? const BennySpinner() : null,
        ),
        SizedBox(height: theme.spacing.spacing16),
      ],
    );
  }
}

class _PasswordChecklist extends StatelessWidget {
  const _PasswordChecklist({required this.state});

  final SignUpState state;

  ValidIconState _ruleState(bool passed) {
    if (state.password.isEmpty) return ValidIconState.unknown;
    return passed ? ValidIconState.valid : ValidIconState.invalid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final strength = state.strength;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing16,
        vertical: theme.spacing.spacing12,
      ),
      decoration: BoxDecoration(
        color: theme.colors.neutral50,
        border: Border.all(color: theme.colors.neutral100),
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius8),
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
    );
  }
}

class _SuccessContent extends StatelessWidget {
  const _SuccessContent({required this.state});

  final SignUpState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Column(
      children: [
        BennyMessage(
          type: BaseMessageType.success,
          title: 'auth.register.success'.tr(),
          message: 'auth.register.email_confirmation'
              .tr(namedArgs: {'user_email': state.email}),
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennySecondaryButton(
          title: 'auth.register.login_go'.tr(),
          isWrapContent: false,
          onPressed: () => context.go(AppRoutes.login),
        ),
      ],
    );
  }
}
