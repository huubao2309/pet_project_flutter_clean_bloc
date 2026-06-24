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
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/sign_up_state.dart';
import '../view_model/sign_up_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';

/// Sign-up screen: collect the phone number and submit. The backend replies
/// with a `verify_otp` challenge (see `signup_success.json`), so on "Continue"
/// we call `signUp()` and route to the OTP screen.
class SignUpPage extends StatelessWidget {
  const SignUpPage({this.prefilledPhone, super.key});

  /// Phone carried over (e.g. from the "recreate deleted account" prompt on
  /// login) so the phone field starts pre-filled.
  final String? prefilledPhone;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<SignUpViewModel>(
      create: (_) {
        final viewModel = getIt<SignUpViewModel>();
        final phone = prefilledPhone;
        if (phone != null && phone.isNotEmpty) {
          // Seed the form state so phone validation / canSubmit reflect it.
          viewModel.onPhoneChanged(phone);
        }
        return viewModel;
      },
      child: _SignUpView(prefilledPhone: prefilledPhone),
    );
  }
}

class _SignUpView extends StatefulWidget {
  const _SignUpView({this.prefilledPhone});

  final String? prefilledPhone;

  @override
  State<_SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<_SignUpView> {
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

    return ViewModelConsumer<SignUpViewModel, SignUpState>(
      listenWhen: (p, c) =>
          p.errorMessage != c.errorMessage ||
          (!p.isSuccess && c.isSuccess) ||
          (p.otpChallenge == null && c.otpChallenge != null),
      listener: (context, state) {
        final message = state.errorMessage;
        if (message != null) {
          BennySnackBar.show(
            message: message,
            type: BaseSnackBarType.error,
          );
        }
        final challenge = state.otpChallenge;
        if (challenge != null) {
          // Sign-up needs OTP verification before completing. Route to the OTP
          // screen, carrying the backend's timer config (same as login).
          context.push(
            Uri(
              path: AppRoutes.otp,
              queryParameters: {
                'phone': state.phone,
                'resend': '${challenge.resendSecs}',
                'enable_resend': '${challenge.enableResendSecs}',
              },
            ).toString(),
          );
          return;
        }
        if (state.isSuccess) {
          BennySnackBar.show(message: 'auth.register.success'.tr());
          context.pushReplacement(
            Uri(
              path: AppRoutes.login,
              queryParameters: {'phone': state.phone},
            ).toString(),
          );
        }
      },
      builder: (context, state) {
        // Hard stop: the phone is blocked from registering (verdict
        // `phone_is_blocked`), surfaced full-screen instead of a snackbar.
        if (state.isBlocked) {
          return AppErrorView(
            icon: Icons.phone_disabled_outlined,
            title: 'auth.register.blocked.title'.tr(),
            description: 'auth.register.blocked.message'.tr(),
            primaryLabel: 'auth.back'.tr(),
            onPrimary: () => context.go(AppRoutes.welcome),
          );
        }

        return Scaffold(
          backgroundColor: theme.colors.surfaceBackground,
          appBar: const AppTopBar(),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(
                    titleKey: 'auth.register.title',
                    captionKey: 'auth.register.caption',
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
            ),
          ),
        );
      },
    );
  }
}

class _FormContent extends StatelessWidget {
  const _FormContent({required this.state, required this.phoneController});

  final SignUpState state;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<SignUpViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          controller: phoneController,
          hintText: 'auth.register.phone'.tr(),
          keyboardType: TextInputType.phone,
          onChanged: viewModel.onPhoneChanged,
          errorText: (state.phone.isNotEmpty && !state.isPhoneValid)
              ? 'auth.phone_invalid'.tr()
              : null,
        ),
        SizedBox(height: theme.spacing.spacing40),
        BennyPrimaryButton(
          title: 'auth.register.continue'.tr(),
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
