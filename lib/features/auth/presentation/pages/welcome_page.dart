import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../base/app_constants.dart';
import '../../../../core/constants/benny_image.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/language_switcher.dart';
import '../../../../core/router/app_routes.dart';

/// Shared height for the two landing CTAs so they align exactly.
const double _kCtaHeight = 50;

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
                BennyImage.logoTile,
                width: 90,
                height: 90,
              ),
              SizedBox(height: theme.spacing.spacing16),
              Text(
                kAppName,
                style: theme.textStyle.heading.copyWith(
                  color: theme.colors.brand800,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: theme.spacing.spacing12),
              Text(
                'welcome.title'.tr(),
                textAlign: TextAlign.center,
                style: theme.textStyle.heading.copyWith(
                  color: theme.colors.brand800,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
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
              // Both CTAs share a fixed height so the filled primary and the
              // outlined secondary line up exactly.
              SizedBox(
                height: _kCtaHeight,
                child: BennyPrimaryButton(
                  title: 'welcome.register'.tr(),
                  isWrapContent: false,
                  onPressed: () => context.push(AppRoutes.signUp),
                ),
              ),
              SizedBox(height: theme.spacing.spacing12),
              SizedBox(
                height: _kCtaHeight,
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => context.push(AppRoutes.login),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: theme.colors.white,
                    foregroundColor: theme.colors.brand600,
                    side: BorderSide(color: theme.colors.brand200),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        theme.borderRadius.borderRadius8,
                      ),
                    ),
                  ),
                  child: Text(
                    'welcome.login'.tr(),
                    style: theme.textStyle.paragraphLabel.copyWith(
                      color: theme.colors.brand600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: theme.spacing.spacing8),
            ],
          ),
        ),
      ),
    );
  }
}
