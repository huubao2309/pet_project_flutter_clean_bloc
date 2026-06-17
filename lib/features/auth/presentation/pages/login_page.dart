import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/loading/spinner/benny_spinner.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/error/app_exception.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_text_field.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../view_model/auth_state.dart';
import '../view_model/auth_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/auth_password_field.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({this.prefilledPhone, super.key});

  /// Phone number carried over from a successful sign-up, so the user only
  /// needs to type the password.
  final String? prefilledPhone;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AuthViewModel>(
      create: (_) => getIt<AuthViewModel>(),
      child: _LoginView(prefilledPhone: prefilledPhone),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView({this.prefilledPhone});

  final String? prefilledPhone;

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  late final TextEditingController _phoneController =
      TextEditingController(text: widget.prefilledPhone ?? '');
  final _passwordController = TextEditingController();

  String? _phoneError;
  String? _passwordError;

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Phone rule (10 digits, starts with 0). [force] also flags an empty field
  /// (used on submit); while typing, an empty field shows no error.
  String? _phoneErrorFor(String value, {bool force = false}) {
    final phone = value.trim();
    if (phone.isEmpty && !force) {
      return null;
    }
    return Validators.isPhoneValid(phone) ? null : 'auth.phone_invalid'.tr();
  }

  /// The login screen does NOT re-validate password rules — those belong on the
  /// sign-up screen. Here the field is simply required; wrong credentials are
  /// reported by the backend (snackbar), not inline.
  String? _passwordErrorFor(String value, {bool force = false}) {
    if (value.isEmpty && force) {
      return 'auth.password_required'.tr();
    }
    return null;
  }

  void _submit() {
    final phoneError = _phoneErrorFor(_phoneController.text, force: true);
    final passwordError = _passwordErrorFor(_passwordController.text, force: true);
    setState(() {
      _phoneError = phoneError;
      _passwordError = passwordError;
    });
    if (phoneError != null || passwordError != null) {
      return;
    }
    context.viewModel<AuthViewModel>().login(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );
  }

  /// Full-screen error for a blocked account; [reason] selects the copy. The
  /// `switch` is exhaustive, so a new [BlockReason] won't compile until it is
  /// given a title/description here.
  Widget _blockedView(BuildContext context, BlockReason reason) {
    final (String title, String description, IconData icon) = switch (reason) {
      BlockReason.otpLimitExceeded => (
          'auth.lock.title'.tr(),
          'auth.lock.otp_message'.tr(),
          Icons.gpp_bad_outlined,
        ),
      BlockReason.accountDeleted => (
          'auth.deleted.title'.tr(),
          'auth.deleted.message'.tr(),
          Icons.person_off_outlined,
        ),
    };
    return AppErrorView(
      icon: icon,
      title: title,
      description: description,
      primaryLabel: 'auth.lock.back'.tr(),
      onPrimary: () => context.viewModel<AuthViewModel>().reset(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return ViewModelConsumer<AuthViewModel, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          getIt<AppRouter>().setLoggedIn(value: true);
          context.go(AppRoutes.main);
          return;
        }
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        // Hard stop: the account is blocked (too many wrong OTP entries, a
        // deleted account, …). The reason drives the text; the exhaustive
        // switch forces a new BlockReason to be given one here.
        if (state is AuthBlocked) {
          return _blockedView(context, state.reason);
        }

        return Scaffold(
          backgroundColor: theme.colors.surfaceBackground,
          appBar: AppTopBar(backgroundColor: theme.colors.surfaceBackground),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(titleKey: 'auth.welcome'),
                  SizedBox(height: theme.spacing.spacing24),
                  AuthCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppTextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          hintText: 'auth.phone'.tr(),
                          errorText: _phoneError,
                          onChanged: (v) =>
                              setState(() => _phoneError = _phoneErrorFor(v)),
                        ),
                        SizedBox(height: theme.spacing.spacing16),
                        AuthPasswordField(
                          controller: _passwordController,
                          hintText: 'auth.password'.tr(),
                          errorText: _passwordError,
                          onTextChanged: (v) => setState(
                            () => _passwordError = _passwordErrorFor(v),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () =>
                                context.push(AppRoutes.forgotPassword),
                            child: Text(
                              'auth.forgot_password'.tr(),
                              style: theme.textStyle.captionDefault.copyWith(
                                color: theme.colors.secondary600,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: theme.spacing.spacing8),
                        BennyPrimaryButton(
                          title: 'auth.login_button'.tr(),
                          isWrapContent: false,
                          onPressed: state is AuthLoading ? null : _submit,
                          widget: state is AuthLoading
                              ? const BennySpinner()
                              : null,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: theme.spacing.spacing20),
                  Center(
                    child: TextButton(
                      onPressed: () => context.push(AppRoutes.signUp),
                      child: Text(
                        'auth.register.submit'.tr(),
                        style: theme.textStyle.paragraphLabel
                            .copyWith(color: theme.colors.brand600),
                      ),
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
