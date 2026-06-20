import 'package:benny_style/snackbar/base_snackbar_type.dart';
import 'package:benny_style/snackbar/benny_snackbar.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../base/app_constants.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/presentation/widgets/language_switcher.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_view_model.dart';
import '../../../auth/presentation/view_model/auth_state.dart';
import '../../../auth/presentation/view_model/auth_view_model.dart';
import '../view_model/profile_state.dart';
import '../view_model/profile_view_model.dart';
import '../widgets/profile_group.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tile.dart';

/// Profile (Hồ sơ) tab — header + grouped settings list, including the working
/// Dark Mode toggle (persisted via [ThemeViewModel]).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<AuthViewModel>(
      create: (_) => getIt<AuthViewModel>(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final themeVm = getIt<ThemeViewModel>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      body: ViewModelListener<AuthViewModel, AuthState>(
        listenWhen: (_, c) => c is AuthUnauthenticated || c is AuthFailure,
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            // Logout succeeded → green success snackbar, then back to welcome.
            getIt<AppRouter>().setLoggedIn(value: false);
            BennySnackBar.show(message: 'profile.logout_success'.tr());
            context.go(AppRoutes.welcome);
          } else if (state is AuthFailure) {
            // Logout failed → keep the session, show the red error snackbar.
            BennySnackBar.show(
              message: state.message,
              type: BaseSnackBarType.error,
            );
          }
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const _ProfileHeaderSection(),
            Padding(
              padding: EdgeInsets.all(theme.spacing.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _GroupLabel('profile.account'.tr(), theme: theme),
                  ProfileGroup(
                    children: [
                      ProfileTile(
                        icon: Icons.manage_accounts_outlined,
                        title: 'profile.edit_info'.tr(),
                        onTap: () => _comingSoon(),
                      ),
                      ProfileTile(
                        icon: Icons.language_outlined,
                        title: 'profile.language'.tr(),
                        value: 'language.${context.locale.languageCode}'.tr(),
                        onTap: () => LanguageSwitcher.showPicker(context),
                      ),
                      const _FingerprintTile(),
                      ProfileTile(
                        icon: Icons.dark_mode_outlined,
                        title: 'profile.dark_mode'.tr(),
                        trailing: Switch.adaptive(
                          value: themeVm.isDark,
                          activeTrackColor: theme.colors.brand600,
                          onChanged: (v) => themeVm.setDark(value: v),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.spacing20),
                  _GroupLabel('profile.support'.tr(), theme: theme),
                  ProfileGroup(
                    children: [
                      ProfileTile(
                        icon: Icons.chat_bubble_outline,
                        title: 'profile.feedback'.tr(),
                        onTap: () => _comingSoon(),
                      ),
                      ProfileTile(
                        icon: Icons.headset_mic_outlined,
                        title: 'profile.support_item'.tr(),
                        onTap: () => _comingSoon(),
                      ),
                      ProfileTile(
                        icon: Icons.description_outlined,
                        title: 'profile.policy'.tr(),
                        onTap: () => _comingSoon(),
                      ),
                      ProfileTile(
                        icon: Icons.star_outline,
                        title: 'profile.rate'.tr(),
                        onTap: () => _comingSoon(),
                      ),
                      ProfileTile(
                        icon: Icons.info_outline,
                        title: 'profile.version'.tr(),
                        value: AppConstants.appVersion,
                        showChevron: false,
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.spacing20),
                  ProfileGroup(
                    children: [
                      ProfileTile(
                        icon: Icons.logout,
                        title: 'profile.logout'.tr(),
                        onTap: () => _confirmLogout(context),
                      ),
                      ProfileTile(
                        icon: Icons.delete_outline,
                        title: 'profile.delete'.tr(),
                        destructive: true,
                        onTap: () => _confirmDelete(context),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.spacing24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _comingSoon() =>
      BennySnackBar.show(message: 'profile.coming_soon'.tr());

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await _confirm(
      context,
      title: 'profile.logout_confirm_title'.tr(),
      message: 'profile.logout_confirm_message'.tr(),
      confirmLabel: 'profile.logout'.tr(),
    );
    if (ok && context.mounted) {
      await context.viewModel<AuthViewModel>().logout();
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final ok = await _confirm(
      context,
      title: 'profile.delete_confirm_title'.tr(),
      message: 'profile.delete_confirm_message'.tr(),
      confirmLabel: 'profile.delete'.tr(),
      destructive: true,
    );
    if (ok) {
      _comingSoon();
    }
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final theme = getIt<ThemeState>();
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: theme.colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      title: Text(
        title,
        style: theme.textStyle.heading
            .copyWith(color: theme.colors.brand800, fontSize: 17),
      ),
      content: Text(
        message,
        style: theme.textStyle.paragraphDefault
            .copyWith(color: theme.colors.neutral600),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(
            'common.cancel'.tr(),
            style: TextStyle(color: theme.colors.neutral500),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            confirmLabel,
            style: TextStyle(
              color: destructive ? theme.colors.error600 : theme.colors.brand600,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Profile header bound to [ProfileViewModel]: shows the fetched name and a
/// masked phone, with a graceful placeholder while the profile loads.
class _ProfileHeaderSection extends StatelessWidget {
  const _ProfileHeaderSection();

  static const _maskedPlaceholder = '••• ••• ••••';

  String _mask(String phone) {
    if (phone.length < 4) {
      return _maskedPlaceholder;
    }
    return '••• ••• ${phone.substring(phone.length - 4)}';
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProfileViewModel, ProfileState>(
      builder: (context, state) {
        final profile = state is ProfileLoaded ? state.profile : null;
        return ProfileHeader(
          name: profile?.fullName ?? 'profile.loading_name'.tr(),
          maskedPhone:
              profile != null ? _mask(profile.phone) : _maskedPlaceholder,
        );
      },
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text, {required this.theme});

  final String text;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: theme.spacing.spacing4,
        bottom: theme.spacing.spacing8,
      ),
      child: Text(
        text.toUpperCase(),
        style: theme.textStyle.captionDefault.copyWith(
          color: theme.colors.neutral400,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

/// Fingerprint login toggle — UI only for now (local state, no backend).
class _FingerprintTile extends StatefulWidget {
  const _FingerprintTile();

  @override
  State<_FingerprintTile> createState() => _FingerprintTileState();
}

class _FingerprintTileState extends State<_FingerprintTile> {
  bool _enabled = false;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    return ProfileTile(
      icon: Icons.fingerprint,
      title: 'profile.fingerprint'.tr(),
      trailing: Switch.adaptive(
        value: _enabled,
        activeTrackColor: theme.colors.brand600,
        onChanged: (v) => setState(() => _enabled = v),
      ),
    );
  }
}
