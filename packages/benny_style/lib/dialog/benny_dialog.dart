import 'package:flutter/material.dart';

import 'package:benny_style/benny_locator.dart';

class BennyDialog {
  static Future<T?> show<T>(Widget child) {
    final theme = bennyTheme;
    final context = bennyNavigatorKey.currentContext;
    if (context == null) return Future<T?>.value();

    return showDialog<T>(
      context: context,
      barrierColor: theme.colors.neutral900.withAlpha((255.0 * 0.25).round()),
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
        ),
        backgroundColor: theme.colors.transparent,
        shadowColor: theme.colors.transparent,
        child: child,
      ),
    );
  }
}
