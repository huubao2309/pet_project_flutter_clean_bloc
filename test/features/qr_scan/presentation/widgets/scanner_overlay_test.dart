import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/features/qr_scan/presentation/widgets/scanner_overlay.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(
        home: Scaffold(
          body: SizedBox(width: 400, height: 800, child: child),
        ),
      );

  testWidgets('builds a CustomPaint viewfinder', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ScannerOverlay(windowSize: 240, borderColor: Colors.amber),
      ),
    );

    expect(find.byType(ScannerOverlay), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);
  });

  testWidgets('repaints as the scan line animates (shouldRepaint true)',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        const ScannerOverlay(windowSize: 240, borderColor: Colors.amber),
      ),
    );

    // Advance the repeating controller so the painter is rebuilt with a new
    // progress value, exercising paint() across frames and shouldRepaint.
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(ScannerOverlay), findsOneWidget);
  });

  testWidgets('disposes the animation controller cleanly', (tester) async {
    await tester.pumpWidget(
      wrap(
        const ScannerOverlay(windowSize: 200, borderColor: Colors.red),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    // Replacing the tree disposes _ScannerOverlayState.
    await tester.pumpWidget(wrap(const SizedBox.shrink()));

    expect(find.byType(ScannerOverlay), findsNothing);
  });
}
