import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../di/injection.dart';
import 'app_overlay_action.dart';
import 'app_sheet_option.dart';
import 'widgets/app_bottom_sheet_scaffold.dart';

/// Single entry point for modal bottom sheets (design §14).
///
/// Use [show] for full control (everything optional), or the convenience
/// builders [options] / [list] / [confirm] / [acknowledge] for the named
/// variants. Chrome (top radius 16, dimmed barrier, grip) lives here so a
/// restyle is one edit instead of every scattered `showModalBottomSheet`.
class AppBottomSheet {
  const AppBottomSheet._();

  /// Shows a sheet with the design-system chrome. Every parameter optional.
  static Future<T?> show<T>({
    String? title,
    Widget? header,
    Widget? body,
    List<Widget>? items,
    List<AppOverlayAction>? actions,
    bool showGrip = true,
    bool showClose = true,
    bool isDismissible = true,
    bool enableDrag = true,
    double? maxHeightFactor,
    Color? backgroundColor,
    EdgeInsets? padding,
    BuildContext? context,
  }) {
    final BuildContext? ctx = context ?? bennyNavigatorKey.currentContext;
    if (ctx == null) {
      return Future<T?>.value();
    }

    final ThemeState theme = getIt<ThemeState>();
    final double factor = (maxHeightFactor ?? 0.9).clamp(0.1, 1.0);

    return showModalBottomSheet<T>(
      context: ctx,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: backgroundColor ?? theme.colors.white,
      barrierColor: theme.colors.neutral900.withAlpha((255.0 * 0.25).round()),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(theme.borderRadius.borderRadius16),
        ),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(ctx).size.height * factor,
      ),
      builder: (_) => AppBottomSheetScaffold(
        title: title,
        header: header,
        body: body,
        items: items,
        actions: actions,
        showGrip: showGrip,
        showClose: showClose,
        padding: padding,
      ),
    );
  }

  /// Grip + title + tappable option rows, no footer (design "BottomSheet.options").
  /// Resolves to the index of the tapped option, or null if dismissed.
  static Future<int?> options({
    required List<AppSheetOption> options,
    String? title,
    bool showClose = false,
    bool isDismissible = true,
    BuildContext? context,
  }) {
    return show<int>(
      context: context,
      title: title,
      showClose: showClose,
      isDismissible: isDismissible,
      items: <Widget>[
        for (int i = 0; i < options.length; i++)
          Builder(
            builder: (rowContext) => options[i].build(
              rowContext,
              onTapOverride: () => Navigator.of(rowContext).pop(i),
            ),
          ),
      ],
    );
  }

  /// Header + scrollable option list + single-button footer
  /// (design "BottomSheet.list"). Resolves to the index of the tapped option.
  ///
  /// By default tapping an option just records the selection; pass
  /// [popOnSelect] true to close immediately on tap (no footer needed).
  static Future<int?> list({
    required String title,
    required List<AppSheetOption> options,
    String? confirmLabel,
    bool popOnSelect = false,
    bool isDismissible = true,
    BuildContext? context,
  }) {
    return show<int>(
      context: context,
      title: title,
      isDismissible: isDismissible,
      items: <Widget>[
        for (int i = 0; i < options.length; i++)
          Builder(
            builder: (rowContext) => options[i].build(
              rowContext,
              onTapOverride: popOnSelect
                  ? () => Navigator.of(rowContext).pop(i)
                  : options[i].onTap,
            ),
          ),
      ],
      actions: popOnSelect
          ? null
          : <AppOverlayAction>[
              AppOverlayAction(label: confirmLabel ?? 'common.confirm'.tr()),
            ],
    );
  }

  /// Header + content + two-button footer (design "BottomSheet.confirm").
  /// Resolves to `true` when confirmed.
  static Future<bool> confirm({
    required String title,
    String? message,
    Widget? content,
    String? confirmLabel,
    String? cancelLabel,
    bool destructive = false,
    bool isDismissible = true,
    BuildContext? context,
  }) async {
    final ThemeState theme = getIt<ThemeState>();
    final bool? result = await show<bool>(
      context: context,
      title: title,
      isDismissible: isDismissible,
      body: content ??
          (message != null
              ? Text(
                  message,
                  style: theme.textStyle.paragraphDefault
                      .copyWith(color: theme.colors.neutral600),
                )
              : null),
      actions: <AppOverlayAction>[
        AppOverlayAction.secondary(
          label: cancelLabel ?? 'common.cancel'.tr(),
          popResult: false,
        ),
        destructive
            ? AppOverlayAction.destructive(
                label: confirmLabel ?? 'common.confirm'.tr(),
                popResult: true,
              )
            : AppOverlayAction(
                label: confirmLabel ?? 'common.confirm'.tr(),
                popResult: true,
              ),
      ],
    );
    return result ?? false;
  }

  /// Header + content + single-button footer (design "BottomSheet.acknowledge").
  static Future<void> acknowledge({
    required String title,
    String? message,
    Widget? content,
    String? buttonLabel,
    bool isDismissible = true,
    BuildContext? context,
  }) {
    final ThemeState theme = getIt<ThemeState>();
    return show<void>(
      context: context,
      title: title,
      isDismissible: isDismissible,
      body: content ??
          (message != null
              ? Text(
                  message,
                  style: theme.textStyle.paragraphDefault
                      .copyWith(color: theme.colors.neutral600),
                )
              : null),
      actions: <AppOverlayAction>[
        AppOverlayAction(label: buttonLabel ?? 'common.close'.tr()),
      ],
    );
  }
}
