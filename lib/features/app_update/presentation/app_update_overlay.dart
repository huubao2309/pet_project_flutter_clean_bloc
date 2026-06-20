import 'dart:async';

import 'package:benny_style/benny_locator.dart';
import 'package:flutter/widgets.dart';

import '../../../core/use_case/use_case.dart';
import '../domain/entities/app_update_info.dart';
import '../domain/entities/app_update_status.dart';
import '../domain/use_cases/check_app_update_use_case.dart';
import '../domain/use_cases/dismiss_optional_update_use_case.dart';
import '../domain/use_cases/open_store_use_case.dart';
import 'widgets/app_update_overlay_view.dart';

/// Presentation orchestrator for the app-update feature.
///
/// Triggered once from the splash screen via [check]. The version check runs in
/// the background and NEVER blocks the splash: the splash routes on as soon as
/// its own bootstrap finishes, regardless of how slow `/app/version` is. When
/// (and if) the backend answers, the prompt is shown as a root [OverlayEntry]
/// on top of whatever screen the user has reached by then:
///  • forced   → non-dismissible (no barrier tap, no Android back button),
///  • optional → dismissible, recorded once per version so it won't nag again.
///
/// An [OverlayEntry] (not a `showDialog` route) is used on purpose: it is
/// independent of the route stack, so the splash's `context.go()` cannot tear it
/// down. This is the same context-free overlay pattern benny_style uses for its
/// snackbars/dialogs (see [bennyNavigatorKey]).
///
/// Registered as a lazy singleton so its single-entry guard survives for the
/// lifetime of the app.
class AppUpdateOverlay {
  AppUpdateOverlay({
    required CheckAppUpdateUseCase checkUseCase,
    required DismissOptionalUpdateUseCase dismissUseCase,
    required OpenStoreUseCase openStoreUseCase,
  })  : _checkUseCase = checkUseCase,
        _dismissUseCase = dismissUseCase,
        _openStoreUseCase = openStoreUseCase;

  final CheckAppUpdateUseCase _checkUseCase;
  final DismissOptionalUpdateUseCase _dismissUseCase;
  final OpenStoreUseCase _openStoreUseCase;

  /// The live overlay entry, or null when nothing is shown. Doubles as a guard
  /// so a second [check] can never stack a second prompt.
  OverlayEntry? _entry;

  /// Kicks off the version check without blocking the caller (the splash).
  void check() => unawaited(_check());

  Future<void> _check() async {
    if (_entry != null) {
      return; // A prompt is already on screen.
    }
    try {
      final status = await _checkUseCase.execute(const NoParams());
      switch (status) {
        case AppUpToDate():
          break;
        case AppOptionalUpdate(:final info):
          _show(info: info, forced: false);
        case AppForcedUpdate(:final info):
          _show(info: info, forced: true);
      }
    } on Exception {
      // An update check must never block the app — fail open (show nothing).
    }
  }

  void _show({required AppUpdateInfo info, required bool forced}) {
    final overlay = bennyNavigatorKey.currentState?.overlay;
    if (overlay == null || _entry != null) {
      return;
    }
    final entry = OverlayEntry(
      builder: (_) => AppUpdateOverlayView(
        forced: forced,
        message: info.message,
        onUpdate: forced ? () => _openStoreUseCase.execute(info.storeUrl) : () => _resolveOptional(info, openStore: true),
        // Forced prompts have no escape; optional ones close and are recorded.
        onCancel: forced ? null : () => _resolveOptional(info, openStore: false),
      ),
    );
    _entry = entry;
    overlay.insert(entry);
  }

  /// Optional flow only: close the prompt, record the dismissal (so it won't
  /// show again until a newer version ships), and route to the store if asked.
  Future<void> _resolveOptional(
    AppUpdateInfo info, {
    required bool openStore,
  }) async {
    _remove();
    await _dismissUseCase.execute(info.latestVersion);
    if (openStore) {
      await _openStoreUseCase.execute(info.storeUrl);
    }
  }

  void _remove() {
    _entry?.remove();
    _entry = null;
  }
}
