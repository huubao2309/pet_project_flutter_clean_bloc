import 'dart:ui' show Locale;

/// Immutable UI state for the splash bootstrap. Library-agnostic.
sealed class SplashState {
  const SplashState();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Bootstrap finished: the View should apply [locale] then route based on
/// [isLoggedIn].
final class SplashReady extends SplashState {
  const SplashReady({required this.locale, required this.isLoggedIn});

  final Locale locale;
  final bool isLoggedIn;
}
