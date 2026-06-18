import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Centered update dialog matching the "Dialog thông báo" style in the design
/// system: icon badge + title + message + action button(s).
///
/// Two flavours:
///  • [AppUpdateDialog.forced] — a single "Update" button; the host shows it
///    non-dismissibly (no barrier tap / back).
///  • [AppUpdateDialog.optional] — "Close" + "Update"; pops `true` to update,
///    `false` to close.
class AppUpdateDialog extends StatelessWidget {
  const AppUpdateDialog._({
    required this.forced,
    required this.message,
    this.onUpdate,
  });

  factory AppUpdateDialog.forced({
    required VoidCallback onUpdate,
    String? message,
  }) =>
      AppUpdateDialog._(forced: true, message: message, onUpdate: onUpdate);

  factory AppUpdateDialog.optional({String? message}) =>
      AppUpdateDialog._(forced: false, message: message);

  final bool forced;
  final String? message;
  final VoidCallback? onUpdate;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final hasServerMessage = message != null && message!.isNotEmpty;
    final description = hasServerMessage
        ? message!
        : (forced ? 'update.force_message' : 'update.message').tr();

    return Dialog(
      backgroundColor: theme.colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Padding(
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
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ),
                  SizedBox(width: theme.spacing.spacing12),
                  Expanded(
                    child: BennyPrimaryButton(
                      title: 'update.update_button'.tr(),
                      isWrapContent: false,
                      onPressed: () => Navigator.of(context).pop(true),
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
