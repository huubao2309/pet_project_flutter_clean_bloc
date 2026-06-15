import 'package:flutter/material.dart';

import 'package:benny_style/benny_locator.dart';

class BennyBottomSheet {
  static Future<void> show({
    required Widget content,
    double? maxHeight,
    Color backgroundColor = Colors.white,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    final theme = bennyTheme;
    final context = bennyNavigatorKey.currentContext;
    if (context == null) return Future<void>.value();

    final screenHeight = MediaQuery.of(context).size.height;

    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      barrierColor: theme.colors.neutral900.withAlpha((255.0 * 0.25).round()),
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(theme.borderRadius.borderRadius8),
            topRight: Radius.circular(theme.borderRadius.borderRadius8),
          ),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? screenHeight * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                height: 36,
                alignment: Alignment.center,
                child: Container(
                  width: 120,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colors.neutral100,
                    borderRadius: BorderRadius.circular(
                      theme.borderRadius.borderRadius4 / 2,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
