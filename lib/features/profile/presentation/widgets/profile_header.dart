import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Navy gradient header of the Profile tab: avatar (user icon + amber edit
/// badge), name and masked phone. The header stays navy in both modes, so its
/// text uses [onColor].
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.name,
    required this.maskedPhone,
    super.key,
  });

  final String name;
  final String maskedPhone;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colors.heroTop, theme.colors.heroBottom],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            theme.spacing.spacing16,
            theme.spacing.spacing16,
            theme.spacing.spacing16,
            theme.spacing.spacing24,
          ),
          child: Column(
            children: [
              _Avatar(theme: theme),
              SizedBox(height: theme.spacing.spacing12),
              Text(
                name,
                style: theme.textStyle.heading.copyWith(
                  color: theme.colors.onColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                maskedPhone,
                style: theme.textStyle.captionDefault.copyWith(
                  color: theme.colors.onColor.withAlpha((255 * 0.75).round()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: Stack(
        children: [
          Container(
            width: 72,
            height: 72,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colors.surfaceElevated,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person, size: 36, color: theme.colors.brand600),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 24,
              height: 24,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: theme.colors.secondary500,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colors.surfaceElevated, width: 2),
              ),
              child: Icon(Icons.edit, size: 12, color: theme.colors.onColor),
            ),
          ),
        ],
      ),
    );
  }
}
