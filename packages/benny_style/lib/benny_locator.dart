import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';

import 'theme/theme_state.dart';

/// Service locator for benny_style.
///
/// benny_style is state-management agnostic at the host level: it uses
/// [GetIt] (the same shared `GetIt.instance` the host app uses) to resolve its
/// [ThemeState]. The host app must register a [ThemeState] before any
/// benny_style widget is built — see `BennyStyleInitializer.ensureInitialized`.
final GetIt bennyLocator = GetIt.instance;

/// Global navigator key used by benny_style to show context-free overlays
/// (snackbar / dialog / bottom sheet), replacing the old GetX overlay APIs.
///
/// The host app must attach this to its navigator (e.g. GoRouter's
/// `navigatorKey: bennyNavigatorKey`).
final GlobalKey<NavigatorState> bennyNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'bennyNavigator');

/// The registered design-system theme. Throws if the host app has not
/// registered a [ThemeState] yet.
ThemeState get bennyTheme => bennyLocator<ThemeState>();

/// A context suitable for showing overlays, or null before the navigator is
/// mounted.
BuildContext? get bennyOverlayContext =>
    bennyNavigatorKey.currentState?.overlay?.context ??
    bennyNavigatorKey.currentContext;
