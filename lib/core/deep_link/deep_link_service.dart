import 'dart:async';

import 'package:app_links/app_links.dart';

import '../router/app_router.dart';
import '../router/app_routes.dart';

/// Listens for incoming deep links (custom scheme / universal links) and routes
/// them through GoRouter. De-GetX'd port of the source `DeeplinkHelper`.
///
/// Supported actions (last path segment):
///  - `resetpassword` → `/reset-password?token=...`
class DeepLinkService {
  DeepLinkService({required AppRouter router, AppLinks? appLinks})
      : _router = router,
        _appLinks = appLinks ?? AppLinks();

  final AppRouter _router;
  final AppLinks _appLinks;
  StreamSubscription<Uri>? _subscription;

  Future<void> init() async {
    // Cold start: handle the link that launched the app, if any.
    final initial = await _appLinks.getInitialLink();
    if (initial != null) _handle(initial);

    // Warm links while the app is running.
    _subscription = _appLinks.uriLinkStream.listen(_handle);
  }

  void _handle(Uri uri) {
    if (uri.pathSegments.isEmpty) return;
    final action = uri.pathSegments.last;

    switch (action) {
      case 'resetpassword':
        final token = uri.queryParameters['token'];
        final path = token == null
            ? AppRoutes.resetPassword
            : '${AppRoutes.resetPassword}?token=$token';
        _router.router.go(path);
      default:
        // Unknown action — ignored.
        break;
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
