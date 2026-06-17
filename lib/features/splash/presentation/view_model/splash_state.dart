import 'dart:ui' show Locale;

/// Immutable UI state for the splash bootstrap. Library-agnostic.
sealed class SplashState {
  const SplashState();
}

final class SplashLoading extends SplashState {
  const SplashLoading();
}

/// Bootstrap finished: the View should apply [locale] and navigate onward.
final class SplashReady extends SplashState {
  const SplashReady(this.locale);
  final Locale locale;
}
