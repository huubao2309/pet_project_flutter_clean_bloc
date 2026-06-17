import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/loading/spinner/benny_spinner.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/otp_state.dart';
import '../view_model/otp_view_model.dart';
import '../widgets/auth_card.dart';
import '../widgets/auth_header.dart';
import '../widgets/otp_input_field.dart';

/// OTP entry screen. Reached after the reset code is sent by SMS.
class OtpPage extends StatelessWidget {
  const OtpPage({this.phone, super.key});

  /// Phone number the code was sent to (shown in the caption).
  final String? phone;

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<OtpViewModel>(
      create: (_) => getIt<OtpViewModel>(),
      child: _OtpView(phone: phone),
    );
  }
}

class _OtpView extends StatelessWidget {
  const _OtpView({this.phone});

  final String? phone;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return ViewModelConsumer<OtpViewModel, OtpState>(
      listenWhen: (p, c) => !p.isVerified && c.isVerified,
      listener: (context, state) {
        // Verified — continue the flow (here: to reset the password).
        context.go(AppRoutes.resetPassword);
      },
      builder: (context, state) {
        if (state.isLocked) {
          return AppErrorView(
            icon: Icons.gpp_bad_outlined,
            title: 'auth.lock.title'.tr(),
            description: 'auth.lock.otp_message'.tr(),
            primaryLabel: 'auth.lock.back'.tr(),
            onPrimary: () => context.go(AppRoutes.login),
          );
        }

        return Scaffold(
          backgroundColor: theme.colors.surfaceBackground,
          appBar: AppTopBar(backgroundColor: theme.colors.surfaceBackground),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(theme.spacing.spacing24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthHeader(
                    titleKey: 'auth.otp.title',
                    captionKey: 'auth.otp.caption',
                    captionArgs: {'phone': phone ?? ''},
                  ),
                  SizedBox(height: theme.spacing.spacing24),
                  AuthCard(child: _OtpForm(state: state)),
                  SizedBox(height: theme.spacing.spacing20),
                  _ResendRow(state: state),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OtpForm extends StatelessWidget {
  const _OtpForm({required this.state});

  final OtpState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<OtpViewModel>();
    final hasError = state.error != OtpError.none;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OtpInputField(
          hasError: hasError,
          onChanged: viewModel.onCodeChanged,
          onCompleted: (_) => viewModel.verify(),
        ),
        if (hasError) ...[
          SizedBox(height: theme.spacing.spacing8),
          Text(
            (state.error == OtpError.expired
                    ? 'auth.otp.error_expired'
                    : 'auth.otp.error_invalid')
                .tr(),
            style: theme.textStyle.captionDefault
                .copyWith(color: theme.colors.error600),
          ),
        ],
        SizedBox(height: theme.spacing.spacing16),
        _CountdownRow(state: state),
        SizedBox(height: theme.spacing.spacing16),
        BennyPrimaryButton(
          title: 'auth.otp.verify'.tr(),
          isWrapContent: false,
          onPressed: state.canVerify ? viewModel.verify : null,
          widget: state.isVerifying ? const BennySpinner() : null,
        ),
      ],
    );
  }
}

class _CountdownRow extends StatelessWidget {
  const _CountdownRow({required this.state});

  final OtpState state;

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final expired = state.secondsLeft == 0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.timer_outlined,
          size: 16,
          color: expired ? theme.colors.error600 : theme.colors.neutral500,
        ),
        SizedBox(width: theme.spacing.spacing4),
        Text(
          expired
              ? 'auth.otp.expired_label'.tr()
              : 'auth.otp.expires_in'
                  .tr(namedArgs: {'time': _format(state.secondsLeft)}),
          style: theme.textStyle.captionDefault.copyWith(
            color: expired ? theme.colors.error600 : theme.colors.neutral500,
          ),
        ),
      ],
    );
  }
}

class _ResendRow extends StatelessWidget {
  const _ResendRow({required this.state});

  final OtpState state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<OtpViewModel>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'auth.otp.no_code'.tr(),
          style: theme.textStyle.paragraphDefault
              .copyWith(color: theme.colors.neutral600),
        ),
        SizedBox(width: theme.spacing.spacing4),
        if (state.canResend)
          GestureDetector(
            onTap: viewModel.resend,
            child: Text(
              'auth.otp.resend'.tr(),
              style: theme.textStyle.paragraphLabel.copyWith(
                color: theme.colors.secondary600,
                fontWeight: FontWeight.w700,
              ),
            ),
          )
        else
          Text(
            'auth.otp.resend_in'
                .tr(namedArgs: {'seconds': '${state.resendIn}'}),
            style: theme.textStyle.paragraphDefault
                .copyWith(color: theme.colors.neutral400),
          ),
      ],
    );
  }
}
