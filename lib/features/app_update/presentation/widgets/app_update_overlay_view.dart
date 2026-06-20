import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Full-screen update prompt shown as a root overlay (see `AppUpdateOverlay`).
///
/// Renders the "Dialog thông báo" card from the design system over a dimmed
/// [ModalBarrier]:
///  • [forced] true  → the barrier ignores taps and the Android back button is
///    swallowed; the only action is "Update". The prompt stays until the app is
///    updated and relaunched.
///  • [forced] false → tapping the barrier or pressing Android back triggers
///    [onCancel]; "Update" runs [onUpdate]. Both close the prompt (the caller
///    records the dismissal so it won't show again until a newer version ships).
class AppUpdateOverlayView extends StatelessWidget {
  const AppUpdateOverlayView({
    required this.forced,
    required this.onUpdate,
    this.onCancel,
    this.message,
    super.key,
  });

  final bool forced;
  final VoidCallback onUpdate;

  /// Dismiss handler for optional updates; null for forced (no way out).
  final VoidCallback? onCancel;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return BackButtonListener(
      // Always swallow the hardware back button so it never pops the screen
      // behind the prompt; for optional updates back also dismisses (no-op when
      // forced, since onCancel is null).
      onBackButtonPressed: () async {
        onCancel?.call();
        return true;
      },
      child: Stack(
        children: [
          ModalBarrier(
            color: Colors.black54,
            dismissible: !forced,
            onDismiss: onCancel,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Material(
                color: Colors.transparent,
                child: _card(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card() {
    final theme = getIt<ThemeState>();
    final hasServerMessage = message != null && message!.isNotEmpty;
    final description = hasServerMessage
        ? message!
        : (forced ? 'update.force_message' : 'update.message').tr();

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.white,
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
        ),
        padding: EdgeInsets.all(theme.spacing.spacing20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: theme.colors.brand50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_download_outlined,
                size: 28,
                color: theme.colors.brand600,
              ),
            ),
            SizedBox(height: theme.spacing.spacing12),
            Text(
              'update.title'.tr(),
              textAlign: TextAlign.center,
              style: theme.textStyle.paragraphLabel.copyWith(
                color: theme.colors.brand800,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: theme.spacing.spacing8),
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textStyle.captionDefault.copyWith(
                color: theme.colors.neutral600,
                height: 1.5,
              ),
            ),
            SizedBox(height: theme.spacing.spacing20),
            if (forced)
              BennyPrimaryButton(
                title: 'update.update_button'.tr(),
                isWrapContent: false,
                onPressed: onUpdate,
              )
            else
              Row(
                children: [
                  Expanded(
                    child: BennySecondaryButton(
                      title: 'update.close_button'.tr(),
                      isWrapContent: false,
                      onPressed: onCancel,
                    ),
                  ),
                  SizedBox(width: theme.spacing.spacing12),
                  Expanded(
                    child: BennyPrimaryButton(
                      title: 'update.update_button'.tr(),
                      isWrapContent: false,
                      onPressed: onUpdate,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
