import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../base/app_constants.dart';
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
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: theme.colors.surfaceBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: const [LanguageSwitcher()],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(theme.spacing.spacing24),
          child: Column(
            children: [
              const Spacer(flex: 3),
              SvgPicture.asset(
                'assets/images/logo_tile.svg',
                width: 96,
                height: 96,
              ),
              SizedBox(height: theme.spacing.spacing20),
              Text(
                kAppName,
                style: theme.textStyle.heading.copyWith(
                  color: theme.colors.brand800,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: theme.spacing.spacing12),
              Text(
                'welcome.title'.tr(),
                textAlign: TextAlign.center,
                style: theme.textStyle.heading.copyWith(
                  color: theme.colors.brand800,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: theme.spacing.spacing8),
              Text(
                'welcome.caption'.tr(),
                textAlign: TextAlign.center,
                style: theme.textStyle.paragraphDefault
                    .copyWith(color: theme.colors.neutral600),
              ),
              const Spacer(flex: 4),
              BennyPrimaryButton(
                title: 'welcome.register'.tr(),
                isWrapContent: false,
                onPressed: () => context.push(AppRoutes.signUp),
              ),
              SizedBox(height: theme.spacing.spacing12),
              BennySecondaryButton(
                title: 'welcome.login'.tr(),
                isWrapContent: false,
                onPressed: () => context.push(AppRoutes.login),
              ),
              SizedBox(height: theme.spacing.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}
