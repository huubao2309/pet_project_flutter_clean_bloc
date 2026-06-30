import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../di/injection.dart';
import 'app_overlay_action.dart';
import 'widgets/app_dialog_content.dart';
import 'widgets/app_overlay_icon.dart';

/// Single entry point for centred dialogs (design §13).
///
/// Use [show] for full control (everything optional), or the convenience
/// builders [confirm] / [destructive] / [acknowledge] for the named variants.
/// Styling lives here and in [AppDialogContent], so a future restyle touches
/// one place instead of every call site's `showDialog`.
class AppDialog {
  const AppDialog._();

  /// Shows a dialog with the design-system chrome (radius 16, dimmed barrier).
  ///
  /// Every parameter is optional. Pass [context] to scope the dialog to a
  /// specific navigator; otherwise the global [bennyNavigatorKey] is used so it
  /// can be called from anywhere (view models, services).
  static Future<T?> show<T>({
    Widget? icon,
    AppOverlayIconType? iconType,
    String? title,
    String? message,
    Widget? content,
    List<AppOverlayAction>? actions,
    bool barrierDismissible = true,
    EdgeInsets? padding,
    BuildContext? context,
  }) {
    final BuildContext? ctx = context ?? bennyNavigatorKey.currentContext;
    if (ctx == null) {
      return Future<T?>.value();
    }

    final ThemeState theme = getIt<ThemeState>();

    return showDialog<T>(
      context: ctx,
      barrierDismissible: barrierDismissible,
      barrierColor: theme.colors.neutral900.withAlpha((255.0 * 0.25).round()),
      builder: (_) => Dialog(
        backgroundColor: theme.colors.transparent,
        shadowColor: theme.colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing24),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
        ),
        child: AppDialogContent(
          icon: icon,
          iconType: iconType,
          title: title,
          message: message,
          content: content,
          actions: actions,
          padding: padding,
        ),
      ),
    );
  }

  /// Two-button confirmation (secondary "cancel" + primary "confirm").
  /// Resolves to `true` when confirmed, `false` otherwise.
  static Future<bool> confirm({
    required String title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    AppOverlayIconType iconType = AppOverlayIconType.confirm,
    bool barrierDismissible = true,
    BuildContext? context,
  }) async {
    final bool? result = await show<bool>(
      context: context,
      iconType: iconType,
      title: title,
      message: message,
      barrierDismissible: barrierDismissible,
      actions: <AppOverlayAction>[
        AppOverlayAction.secondary(
          label: cancelLabel ?? 'common.cancel'.tr(),
          popResult: false,
        ),
        AppOverlayAction(
          label: confirmLabel ?? 'common.confirm'.tr(),
          popResult: true,
        ),
      ],
    );
    return result ?? false;
  }

  /// Two-button destructive confirmation (secondary "cancel" + red action).
  /// Resolves to `true` when the destructive action is chosen.
  static Future<bool> destructive({
    required String title,
    String? message,
    String? confirmLabel,
    String? cancelLabel,
    AppOverlayIconType iconType = AppOverlayIconType.warning,
    bool barrierDismissible = true,
    BuildContext? context,
  }) async {
    final bool? result = await show<bool>(
      context: context,
      iconType: iconType,
      title: title,
      message: message,
      barrierDismissible: barrierDismissible,
      actions: <AppOverlayAction>[
        AppOverlayAction.secondary(
          label: cancelLabel ?? 'common.cancel'.tr(),
          popResult: false,
        ),
        AppOverlayAction.destructive(
          label: confirmLabel ?? 'common.confirm'.tr(),
          popResult: true,
        ),
      ],
    );
    return result ?? false;
  }

  /// Single-button notice (design "Dialog.acknowledge").
  static Future<void> acknowledge({
    String? title,
    String? message,
    String? buttonLabel,
    AppOverlayIconType iconType = AppOverlayIconType.success,
    Widget? content,
    bool barrierDismissible = true,
    BuildContext? context,
  }) {
    return show<void>(
      context: context,
      iconType: iconType,
      title: title,
      message: message,
      content: content,
      barrierDismissible: barrierDismissible,
      actions: <AppOverlayAction>[
        AppOverlayAction(label: buttonLabel ?? 'common.close'.tr()),
      ],
    );
  }
}
