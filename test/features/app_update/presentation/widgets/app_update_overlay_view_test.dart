import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/theme/benny_style_initializer.dart';
import 'package:pet_project_flutter_clean_bloc/features/app_update/presentation/widgets/app_update_overlay_view.dart';

import '../../../../helpers/localization_test_harness.dart';

/// Minimal [RouterDelegate] that just renders a fixed widget. The production
/// app shows the overlay under go_router's `MaterialApp.router`, so the view's
/// [BackButtonListener] expects a [Router] ancestor; this provides one.
class _StaticRouterDelegate extends RouterDelegate<Object> with ChangeNotifier {
  _StaticRouterDelegate(this.child);

  final Widget child;

  @override
  Widget build(BuildContext context) => child;

  // Let the BackButtonListener (a higher-priority child dispatcher) handle back;
  // this fallback never gets to run in these tests.
  @override
  Future<bool> popRoute() async => false;

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

void main() {
  setUpAll(() async {
    await LocalizationTestHarness.useRealTranslations();
    BennyStyleInitializer.ensureInitialized();
  });

  // Wrap the view in a real Router (with a root back-button dispatcher) so the
  // BackButtonListener resolves and the `popRoute` platform message reaches it.
  Widget wrap(Widget child) => MaterialApp.router(
        routerDelegate: _StaticRouterDelegate(Scaffold(body: child)),
        backButtonDispatcher: RootBackButtonDispatcher(),
      );

  testWidgets('forced mode shows only the update button and no escape',
      (tester) async {
    var updated = 0;
    await tester.pumpWidget(
      wrap(
        AppUpdateOverlayView(
          forced: true,
          onUpdate: () => updated++,
        ),
      ),
    );

    expect(find.text('update.title'.tr()), findsOneWidget);
    expect(find.text('update.force_message'.tr()), findsOneWidget);
    expect(find.text('update.update_button'.tr()), findsOneWidget);
    expect(find.text('update.close_button'.tr()), findsNothing);

    // Barrier is non-dismissible in forced mode.
    final barrier = tester.widget<ModalBarrier>(find.byType(ModalBarrier));
    expect(barrier.dismissible, isFalse);

    await tester.tap(find.text('update.update_button'.tr()));
    expect(updated, 1);
  });

  testWidgets('optional mode shows both buttons and drives callbacks',
      (tester) async {
    var updated = 0;
    var cancelled = 0;
    await tester.pumpWidget(
      wrap(
        AppUpdateOverlayView(
          forced: false,
          onUpdate: () => updated++,
          onCancel: () => cancelled++,
        ),
      ),
    );

    expect(find.text('update.message'.tr()), findsOneWidget);
    expect(find.text('update.close_button'.tr()), findsOneWidget);
    expect(find.text('update.update_button'.tr()), findsOneWidget);

    final barrier = tester.widget<ModalBarrier>(find.byType(ModalBarrier));
    expect(barrier.dismissible, isTrue);

    await tester.tap(find.text('update.update_button'.tr()));
    await tester.tap(find.text('update.close_button'.tr()));
    expect(updated, 1);
    expect(cancelled, 1);
  });

  testWidgets('prefers a server-provided message over localized copy',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        AppUpdateOverlayView(
          forced: false,
          onUpdate: () {},
          onCancel: () {},
          message: 'Critical security patch',
        ),
      ),
    );

    expect(find.text('Critical security patch'), findsOneWidget);
    expect(find.text('update.message'.tr()), findsNothing);
  });

  testWidgets('hardware back triggers onCancel for optional updates',
      (tester) async {
    var cancelled = 0;
    await tester.pumpWidget(
      wrap(
        AppUpdateOverlayView(
          forced: false,
          onUpdate: () {},
          onCancel: () => cancelled++,
        ),
      ),
    );

    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      'flutter/navigation',
      const JSONMethodCodec().encodeMethodCall(
        const MethodCall('popRoute'),
      ),
      (_) {},
    );
    await tester.pump();

    expect(cancelled, 1);
  });
}
