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
import '../view_model/forgot_password_state.dart';
import '../view_model/forgot_password_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({this.prefilledPhone, super.key});

  /// Phone carried over from the Login screen so the field starts pre-filled.
  final String? prefilledPhone;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<ForgotPasswordViewModel>(
      create: (_) {
        final viewModel = getIt<ForgotPasswordViewModel>();
        final phone = prefilledPhone;
        if (phone != null && phone.isNotEmpty) {
          viewModel.onPhoneChanged(phone);
        }
        return viewModel;
      },
      child: _ForgotPasswordView(prefilledPhone: prefilledPhone),
    );
  }
}

class _ForgotPasswordView extends StatefulWidget {
  const _ForgotPasswordView({this.prefilledPhone});

  final String? prefilledPhone;

  @override
  State<_ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<_ForgotPasswordView> {
  late final TextEditingController _phoneController =
      TextEditingController(text: widget.prefilledPhone ?? '');

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppTopBar(backgroundColor: theme.colors.surfaceBackground),
      body: SafeArea(
        child: ViewModelConsumer<ForgotPasswordViewModel, ForgotPasswordState>(
          // Surface errors, and on a successful send go straight to the OTP
          // screen (no intermediate "code sent" step — per design).
          listenWhen: (p, c) =>
              p.errorMessage != c.errorMessage ||
              (p.otpChallenge == null && c.otpChallenge != null),
          listener: (context, state) {
            final message = state.errorMessage;
            if (message != null) {
              BennySnackBar.show(
                message: message,
                type: BaseSnackBarType.error,
              );
            }
            if (state.otpChallenge != null) {
              context.push(
                Uri(
                  path: AppRoutes.otp,
                  queryParameters: {
                    'phone': state.phone.trim(),
                  },
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
                    titleKey: 'auth.forgot.title',
                    captionKey: 'auth.forgot.caption',
                  ),
                  SizedBox(height: theme.spacing.spacing24),
                  AuthCard(
                    child: _FormContent(
                      state: state,
                      phoneController: _phoneController,
                    ),
                  ),
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
  const _FormContent({required this.state, required this.phoneController});

  final ForgotPasswordState state;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<ForgotPasswordViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: phoneController,
          hintText: 'auth.forgot.phone'.tr(),
          keyboardType: TextInputType.phone,
          onChanged: viewModel.onPhoneChanged,
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
