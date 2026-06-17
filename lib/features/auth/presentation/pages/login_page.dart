import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/validators.dart';
import '../view_model/auth_state.dart';
import '../view_model/auth_view_model.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AuthViewModel>(
      create: (_) => getIt<AuthViewModel>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.viewModel<AuthViewModel>().login(
          phone: _phoneController.text.trim(),
          password: _passwordController.text,
        );
  }

  String? _validatePhone(String? value) {
    final phone = (value ?? '').trim();
    if (!Validators.isPhoneValid(phone)) {
      return 'auth.phone_invalid'.tr();
    }
    return null;
  }

  /// Reuses the sign-up password rules, but reports each failing condition as
  /// an error line under the field (instead of a checklist box).
  String? _validatePassword(String? value) {
    final password = value ?? '';
    final failed = <String>[];
    if (!Validators.hasMinLength(password)) {
      failed.add('auth.register.password_length'.tr());
    }
    if (!Validators.hasSpecialChar(password)) {
      failed.add('auth.register.password_special'.tr());
    }
    if (!Validators.hasNumber(password)) {
      failed.add('auth.register.password_number'.tr());
    }
    if (!Validators.hasCapital(password)) {
      failed.add('auth.register.password_capital'.tr());
    }
    if (failed.isEmpty) {
      return null;
    }
    return failed.join('\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ViewModelListener<AuthViewModel, AuthState>(
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
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'auth.welcome'.tr(),
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'auth.phone'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    validator: _validatePhone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'auth.password'.tr(),
                      border: const OutlineInputBorder(),
                      // Show every failing password rule (one per line).
                      errorMaxLines: 5,
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 24),
                  ViewModelBuilder<AuthViewModel, AuthState>(
                    builder: (context, state) => FilledButton(
                      onPressed: state is AuthLoading ? null : _submit,
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text('auth.login_button'.tr()),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text('auth.forgot_password'.tr()),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.signUp),
                    child: Text('auth.register.button'.tr()),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
