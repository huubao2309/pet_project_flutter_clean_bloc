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
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/sign_up_state.dart';
import '../view_model/sign_up_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';
import '../widgets/password_requirement_hint.dart';

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
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppTopBar(backgroundColor: theme.colors.surfaceBackground),
      body: SafeArea(
        child: ViewModelConsumer<SignUpViewModel, SignUpState>(
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
              BennySnackBar.show(message: 'auth.register.success'.tr());
              // Replace sign-up with login, carrying the phone so the user only
              // needs to type the password.
              context.pushReplacement(
                Uri(
                  path: AppRoutes.login,
                  queryParameters: {'phone': state.phone},
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
                    titleKey: 'auth.register.title',
                    captionKey: 'auth.register.caption',
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

  final SignUpState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<SignUpViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          hintText: 'auth.register.phone'.tr(),
          keyboardType: TextInputType.phone,
          onChanged: viewModel.onPhoneChanged,
          errorText: (state.phone.isNotEmpty && !state.isPhoneValid)
              ? 'auth.phone_invalid'.tr()
              : null,
        ),
        SizedBox(height: theme.spacing.spacing12),
        AuthPasswordField(
          hintText: 'auth.register.password'.tr(),
          onTextChanged: viewModel.onPasswordChanged,
        ),
        SizedBox(height: theme.spacing.spacing8),
        PasswordRequirementHint(state: state),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.register.submit'.tr(),
          isWrapContent: false,
          onPressed:
              (state.canSubmit && !state.isLoading) ? viewModel.signUp : null,
          widget: state.isLoading ? const BennySpinner() : null,
        ),
        SizedBox(height: theme.spacing.spacing16),
      ],
    );
  }
}
