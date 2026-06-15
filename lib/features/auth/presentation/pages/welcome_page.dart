import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/language_switcher.dart';
import '../../../../core/router/app_routes.dart';

/// Landing screen for unauthenticated users. Pure navigation — no view model
/// needed (no business logic or async state to hold).
class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.neutral25,
      appBar: AppBar(
        backgroundColor: theme.colors.neutral25,
        elevation: 0,
        actions: const [LanguageSwitcher()],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.home_work_rounded,
                size: 48,
                color: theme.colors.brand700,
              ),
              SizedBox(height: theme.spacing.spacing40),
              Text(
                'welcome.title'.tr(),
                style: theme.textStyle.heading
                    .copyWith(color: theme.colors.neutral900),
              ),
              SizedBox(height: theme.spacing.spacing8),
              Text(
                'welcome.caption'.tr(),
                style: theme.textStyle.paragraphDefault
                    .copyWith(color: theme.colors.neutral700),
              ),
              SizedBox(height: theme.spacing.spacing40),
              BennySecondaryButton(
                title: 'welcome.login'.tr(),
                isWrapContent: false,
                onPressed: () => context.push(AppRoutes.login),
              ),
              SizedBox(height: theme.spacing.spacing12),
              BennyPrimaryButton(
                title: 'welcome.register'.tr(),
                isWrapContent: false,
                onPressed: () => context.push(AppRoutes.signUp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
