import 'package:flutter/material.dart';
import 'package:benny_style/theme/theme_state.dart';

import '../../../di/injection.dart';
import '../app_overlay_action.dart';
import 'app_overlay_actions.dart';

/// The shared layout for every bottom sheet (design §14):
///
/// grip → header (title + close) → scrollable body → sticky footer.
///
/// Header and footer stay pinned; only the body scrolls. All sections optional.
class AppBottomSheetScaffold extends StatelessWidget {
  const AppBottomSheetScaffold({
    super.key,
    this.title,
    this.header,
    this.body,
    this.items,
    this.actions,
    this.showGrip = true,
    this.showClose = true,
    this.onClose,
    this.padding,
  });

  /// Header title text. Ignored when [header] is supplied.
  final String? title;

  /// Full custom header, replacing the [title] + close row.
  final Widget? header;

  /// Scrollable body content. Ignored when [items] is supplied.
  final Widget? body;

  /// Pre-built rows for the scrollable body (e.g. option rows).
  final List<Widget>? items;

  /// Footer buttons.
  final List<AppOverlayAction>? actions;

  final bool showGrip;
  final bool showClose;

  /// Tap handler for the close (✕) button. Defaults to popping the sheet.
  final VoidCallback? onClose;

  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    final ThemeState theme = getIt<ThemeState>();
    final EdgeInsets pad = padding ??
        EdgeInsets.fromLTRB(
          theme.spacing.spacing16,
          theme.spacing.spacing12,
          theme.spacing.spacing16,
          theme.spacing.spacing20,
        );

    return SafeArea(
      top: false,
      child: Padding(
        padding: pad,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (showGrip) _grip(theme),
            ..._buildHeader(theme, context),
            ..._buildBody(theme),
            ..._buildFooter(theme),
          ],
        ),
      ),
    );
  }

  Widget _grip(ThemeState theme) {
    return Padding(
      padding: EdgeInsets.only(bottom: theme.spacing.spacing12),
      child: Center(
        child: Container(
          width: 36,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colors.neutral200,
            borderRadius:
                BorderRadius.circular(theme.borderRadius.borderRadius4),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeader(ThemeState theme, BuildContext context) {
    if (header != null) {
      return <Widget>[header!, SizedBox(height: theme.spacing.spacing12)];
    }
    if (title == null) {
      return const <Widget>[];
    }

    return <Widget>[
      Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title!,
              style: theme.textStyle.heading.copyWith(
                color: theme.colors.brand800,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (showClose)
            InkWell(
              onTap: onClose ?? () => Navigator.of(context).maybePop(),
              borderRadius:
                  BorderRadius.circular(theme.borderRadius.borderRadius16),
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.spacing4),
                child: Icon(
                  Icons.close_rounded,
                  size: 22,
                  color: theme.colors.neutral500,
                ),
              ),
            ),
        ],
      ),
      SizedBox(height: theme.spacing.spacing12),
    ];
  }

  List<Widget> _buildBody(ThemeState theme) {
    final Widget? content = items != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items!,
          )
        : body;
    if (content == null) {
      return const <Widget>[];
    }

    return <Widget>[
      Flexible(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: content,
        ),
      ),
    ];
  }

  List<Widget> _buildFooter(ThemeState theme) {
    final List<AppOverlayAction> acts = actions ?? const <AppOverlayAction>[];
    if (acts.isEmpty) {
      return const <Widget>[];
    }

    return <Widget>[
      SizedBox(height: theme.spacing.spacing16),
      AppOverlayActions(actions: acts),
    ];
  }
}
