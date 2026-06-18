import 'package:flutter/material.dart';

/// Full-screen dark scrim with a transparent square cut-out, amber corner
/// brackets and a sweeping scan line — the viewfinder framing for the QR
/// scanner. [windowSize] must match the [MobileScanner.scanWindow] so the
/// cut-out lines up with the actual detection region.
class ScannerOverlay extends StatefulWidget {
  const ScannerOverlay({
    required this.windowSize,
    required this.borderColor,
    super.key,
  });

  final double windowSize;
  final Color borderColor;

  @override
  State<ScannerOverlay> createState() => _ScannerOverlayState();
}

class _ScannerOverlayState extends State<ScannerOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        size: Size.infinite,
        painter: _OverlayPainter(
          windowSize: widget.windowSize,
          borderColor: widget.borderColor,
          progress: _controller.value,
        ),
      ),
    );
  }
}

class _OverlayPainter extends CustomPainter {
  _OverlayPainter({
    required this.windowSize,
    required this.borderColor,
    required this.progress,
  });

  final double windowSize;
  final Color borderColor;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final window = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: windowSize,
      height: windowSize,
    );
    const radius = Radius.circular(24);
    final windowRRect = RRect.fromRectAndRadius(window, radius);

    // Dim everything except the scan window.
    final scrim = Path()
      ..addRect(Offset.zero & size)
      ..addRRect(windowRRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(scrim, Paint()..color = Colors.black.withAlpha(140));

    // Corner brackets.
    final bracket = Paint()
      ..color = borderColor
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    const len = 30.0;
    // top-left
    canvas
      ..drawLine(window.topLeft + const Offset(0, len),
          window.topLeft + const Offset(0, 14), bracket,)
      ..drawLine(window.topLeft + const Offset(14, 0),
          window.topLeft + const Offset(len, 0), bracket,)
      // top-right
      ..drawLine(window.topRight + const Offset(-len, 0),
          window.topRight + const Offset(-14, 0), bracket,)
      ..drawLine(window.topRight + const Offset(0, 14),
          window.topRight + const Offset(0, len), bracket,)
      // bottom-left
      ..drawLine(window.bottomLeft + const Offset(0, -len),
          window.bottomLeft + const Offset(0, -14), bracket,)
      ..drawLine(window.bottomLeft + const Offset(14, 0),
          window.bottomLeft + const Offset(len, 0), bracket,)
      // bottom-right
      ..drawLine(window.bottomRight + const Offset(-len, 0),
          window.bottomRight + const Offset(-14, 0), bracket,)
      ..drawLine(window.bottomRight + const Offset(0, -14),
          window.bottomRight + const Offset(0, -len), bracket,);

    // Sweeping scan line.
    final lineY = window.top + 16 + (window.height - 32) * progress;
    final glow = Paint()
      ..color = borderColor
      ..strokeWidth = 2
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawLine(
      Offset(window.left + 16, lineY),
      Offset(window.right - 16, lineY),
      glow,
    );
  }

  @override
  bool shouldRepaint(_OverlayPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.windowSize != windowSize ||
      oldDelegate.borderColor != borderColor;
}
