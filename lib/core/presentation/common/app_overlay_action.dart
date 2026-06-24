import 'package:flutter/material.dart';
import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';

/// A single button rendered in a dialog / bottom-sheet footer.
///
/// Immutable value object — every field is optional so a call site can declare
/// just what it needs. `const AppOverlayAction(label: 'OK')` is a complete
/// primary button that dismisses the overlay on tap.
///
/// Use the named constructors for the design-system variants:
/// * [AppOverlayAction.new] — filled primary (brand) button.
/// * [AppOverlayAction.secondary] — outlined neutral "cancel"-style button.
/// * [AppOverlayAction.destructive] — filled error (red) button.
@immutable
class AppOverlayAction {
  const AppOverlayAction({
    this.label,
    this.onPressed,
    this.child,
    this.isPrimary = true,
    this.type = BaseButtonType.brand,
    this.dismissOnTap = true,
    this.popResult,
  });

  /// Outlined neutral button — the design-system "Huỷ" / secondary action.
  const AppOverlayAction.secondary({
    String? label,
    VoidCallback? onPressed,
    Widget? child,
    bool dismissOnTap = true,
    Object? popResult,
  }) : this(
          label: label,
          onPressed: onPressed,
          child: child,
          isPrimary: false,
          type: BaseButtonType.neutral,
          dismissOnTap: dismissOnTap,
          popResult: popResult,
        );

  /// Filled error (red) button — the design-system destructive action ("Xoá").
  const AppOverlayAction.destructive({
    String? label,
    VoidCallback? onPressed,
    Widget? child,
    bool dismissOnTap = true,
    Object? popResult,
  }) : this(
          label: label,
          onPressed: onPressed,
          child: child,
          isPrimary: true,
          type: BaseButtonType.error,
          dismissOnTap: dismissOnTap,
          popResult: popResult,
        );

  /// Text shown on the button. Ignored when [child] is provided.
  final String? label;

  /// Tap callback. Runs after the overlay is popped when [dismissOnTap] is true.
  final VoidCallback? onPressed;

  /// Full custom content, overriding [label].
  final Widget? child;

  /// Filled (primary) vs outlined (secondary) visual style.
  final bool isPrimary;

  /// Colour role (brand / error / success / neutral).
  final BaseButtonType type;

  /// Whether tapping closes the overlay before running [onPressed].
  final bool dismissOnTap;

  /// Value the overlay's `Navigator.pop` returns when this action is tapped.
  /// Lets `await AppDialog.show<T>()` resolve to a meaningful result.
  final Object? popResult;

  /// True when tapping does anything at all (dismisses and/or calls back).
  bool get _isEnabled => dismissOnTap || onPressed != null;

  void _handle(BuildContext context) {
    if (dismissOnTap && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(popResult);
    }
    onPressed?.call();
  }

  /// Builds the button widget. [expand] makes it fill the available width
  /// (used when the action sits alone or stacked in a column).
  Widget build(BuildContext context, {bool expand = false}) {
    final VoidCallback? handler = _isEnabled ? () => _handle(context) : null;
    if (isPrimary) {
      return BennyPrimaryButton(
        title: label ?? '',
        widget: child,
        onPressed: handler,
        isWrapContent: !expand,
        type: type,
      );
    }
    return BennySecondaryButton(
      title: label ?? '',
      widget: child,
      onPressed: handler,
      isWrapContent: !expand,
      type: type,
    );
  }
}
