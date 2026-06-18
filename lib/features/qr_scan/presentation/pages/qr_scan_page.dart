import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/di/injection.dart';
import '../../data/scanned_property_resolver.dart';
import '../widgets/scan_result_sheet.dart';
import '../widgets/scanner_overlay.dart';

/// Full-screen in-app QR scanner (powered by `mobile_scanner`). Frames a scan
/// window, lets the collaborator toggle the torch, and on a successful scan
/// surfaces the resolved property in a bottom sheet.
class QrScanPage extends StatefulWidget {
  const QrScanPage({super.key});

  static const double _windowSize = 240;

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );

  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handled) {
      return;
    }
    final code = capture.barcodes
        .map((b) => b.rawValue)
        .firstWhere((v) => v != null && v.isNotEmpty, orElse: () => null);
    if (code == null) {
      return;
    }

    _handled = true;
    await _controller.stop();
    if (!mounted) {
      return;
    }

    final property = ScannedPropertyResolver.resolve(code);
    final action = await showScanResultSheet(context, property);
    if (!mounted) {
      return;
    }

    if (action == ScanResultAction.scanAgain) {
      _handled = false;
      await _controller.start();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final scanWindow = Rect.fromCenter(
            center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
            width: QrScanPage._windowSize,
            height: QrScanPage._windowSize,
          );

          return Stack(
            children: [
              MobileScanner(
                controller: _controller,
                onDetect: _onDetect,
                scanWindow: scanWindow,
                errorBuilder: (context, error) =>
                    _PermissionView(error: error, controller: _controller),
              ),
              IgnorePointer(
                child: ScannerOverlay(
                  windowSize: QrScanPage._windowSize,
                  borderColor: theme.colors.secondary500,
                ),
              ),
              _TopBar(controller: _controller, theme: theme),
              _Hint(theme: theme),
              _BottomControls(controller: _controller, theme: theme),
            ],
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller, required this.theme});

  final MobileScannerController controller;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _CircleButton(
              icon: Icons.close_rounded,
              onTap: () => Navigator.of(context).maybePop(),
            ),
            Text(
              'qr.title'.tr(),
              style: theme.textStyle.paragraphLabel.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            ValueListenableBuilder<MobileScannerState>(
              valueListenable: controller,
              builder: (context, state, _) {
                final on = state.torchState == TorchState.on;
                return _CircleButton(
                  icon: on ? Icons.flash_on_rounded : Icons.flash_off_rounded,
                  highlight: on,
                  onTap: controller.toggleTorch,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, 0.55),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing40),
        child: Text(
          'qr.hint'.tr(),
          textAlign: TextAlign.center,
          style: theme.textStyle.paragraphDefault
              .copyWith(color: Colors.white.withAlpha((255 * 0.8).round())),
        ),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({required this.controller, required this.theme});

  final MobileScannerController controller;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: theme.spacing.spacing24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder<MobileScannerState>(
                valueListenable: controller,
                builder: (context, state, _) => _PillButton(
                  icon: Icons.bolt_rounded,
                  label: 'qr.flash'.tr(),
                  active: state.torchState == TorchState.on,
                  onTap: controller.toggleTorch,
                  theme: theme,
                ),
              ),
              SizedBox(width: theme.spacing.spacing12),
              _PillButton(
                icon: Icons.photo_outlined,
                label: 'qr.gallery'.tr(),
                onTap: () => _analyzeFromGallery(context),
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _analyzeFromGallery(BuildContext context) async {
    // Picking from the gallery needs an image picker plugin; surface a hint in
    // the mock build instead of failing silently.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('qr.gallery_unavailable'.tr())),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.highlight = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: highlight
              ? Colors.amber.withAlpha((255 * 0.85).round())
              : Colors.white.withAlpha((255 * 0.14).round()),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.theme,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ThemeState theme;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.spacing16,
          vertical: theme.spacing.spacing12,
        ),
        decoration: BoxDecoration(
          color: active
              ? theme.colors.secondary500.withAlpha((255 * 0.9).round())
              : Colors.white.withAlpha((255 * 0.14).round()),
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(
              label,
              style:
                  theme.textStyle.captionDefault.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown by [MobileScanner]'s errorBuilder, primarily when camera permission is
/// denied. Offers a retry that re-attempts to start the camera.
class _PermissionView extends StatelessWidget {
  const _PermissionView({required this.error, required this.controller});

  final MobileScannerException error;
  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color:
                      theme.colors.secondary500.withAlpha((255 * 0.15).round()),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.photo_camera_outlined,
                    size: 42, color: theme.colors.secondary300,),
              ),
              SizedBox(height: theme.spacing.spacing20),
              Text(
                'qr.permission_title'.tr(),
                textAlign: TextAlign.center,
                style: theme.textStyle.heading.copyWith(color: Colors.white),
              ),
              SizedBox(height: theme.spacing.spacing8),
              Text(
                'qr.permission_message'.tr(),
                textAlign: TextAlign.center,
                style: theme.textStyle.paragraphDefault.copyWith(
                  color: Colors.white.withAlpha((255 * 0.65).round()),
                ),
              ),
              SizedBox(height: theme.spacing.spacing24),
              FilledButton(
                onPressed: () => controller.start(),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colors.secondary500,
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.spacing28,
                    vertical: theme.spacing.spacing12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(theme.borderRadius.borderRadius8),
                  ),
                ),
                child: Text('qr.permission_grant'.tr()),
              ),
              SizedBox(height: theme.spacing.spacing12),
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(),
                child: Text(
                  'qr.permission_later'.tr(),
                  style: theme.textStyle.paragraphDefault.copyWith(
                    color: Colors.white.withAlpha((255 * 0.6).round()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
