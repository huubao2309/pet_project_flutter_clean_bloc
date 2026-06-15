import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/icon_button/benny_ghost_icon_button.dart';
import 'package:benny_style/generated/assets.gen.dart';
import 'package:benny_style/infor_bar/benny_infor_bar.dart';
import 'package:benny_style/benny_style.dart';
import 'base_snackbar_type.dart';

/// Where the snackbar is anchored. Replaces the old GetX `SnackPosition`.
enum BennySnackPosition { top, bottom }

/// Context-free snackbar, shown through [bennyNavigatorKey]'s overlay
/// (previously implemented with GetX `Get.snackbar`).
class BennySnackBar {
  static void show({
    BaseSnackBarType type = BaseSnackBarType.success,
    String? title,
    required String message,
    VoidCallback? onUndo,
    Duration duration = const Duration(seconds: 5),
    BennySnackPosition position = BennySnackPosition.bottom,
    double borderRadius = 8,
    EdgeInsets margin = const EdgeInsets.all(16),
  }) {
    final overlay = bennyNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    late OverlayEntry entry;
    void dismiss() {
      if (entry.mounted) entry.remove();
    }

    entry = OverlayEntry(
      builder: (_) => _BennySnackBarOverlay(
        type: type,
        message: message,
        onUndo: onUndo,
        duration: duration,
        position: position,
        borderRadius: borderRadius,
        margin: margin,
        onClose: dismiss,
      ),
    );

    overlay.insert(entry);
    Future<void>.delayed(duration, dismiss);
  }
}

class _BennySnackBarOverlay extends StatelessWidget {
  const _BennySnackBarOverlay({
    required this.type,
    required this.message,
    required this.onUndo,
    required this.duration,
    required this.position,
    required this.borderRadius,
    required this.margin,
    required this.onClose,
  });

  final BaseSnackBarType type;
  final String message;
  final VoidCallback? onUndo;
  final Duration duration;
  final BennySnackPosition position;
  final double borderRadius;
  final EdgeInsets margin;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: position == BennySnackPosition.top
            ? Alignment.topCenter
            : Alignment.bottomCenter,
        child: Padding(
          padding: margin,
          child: Material(
            color: Colors.transparent,
            child: _card(),
          ),
        ),
      ),
    );
  }

  Widget _card() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: BennyStyle.instance.color.neutral.color900
                .withAlpha((255.0 * 0.08).round()),
            spreadRadius: 8,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: BennyStyle.instance.color.neutral.color900
                .withAlpha((255.0 * 0.02).round()),
            spreadRadius: 8,
            blurRadius: 6,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: type.borderColor, width: 1),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BennyInfoBar(
              type: type.infoType,
              height: BennyStyle.instance.borderRadius.small,
              duration: duration.inSeconds,
              beginValue: 1,
              autoStart: true,
              endValue: 0,
            ),
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: SvgPicture.asset(
                      type.iconName,
                      colorFilter:
                          ColorFilter.mode(type.iconColor, BlendMode.srcIn),
                    ),
                  ),
                  Expanded(
                    child: Text(message, style: type.messageTextStyle),
                  ),
                  if (onUndo != null)
                    RichText(
                      text: TextSpan(
                        text: 'Undo',
                        style: type.undoTextStyle,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            onClose();
                            onUndo!();
                          },
                      ),
                    ),
                  BennyGhostIconButton(
                    onPressed: onClose,
                    type: BaseButtonType.neutral,
                    svgIconName: Assets.svg.icCloseSmall.keyName,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
