import "package:flutter/material.dart";
import 'package:benny_style/colors/benny_color.dart';
import 'package:benny_style/benny_style.dart';

/// Brightness-aware colour tokens. The same getters return Light or Dark Mode
/// values depending on [brightness], so the whole app (and benny_style
/// components) flips when [brightness] changes and the widget tree rebuilds.
///
/// Rule: every token has a Light AND a Dark value. `white` is the card/surface
/// token (becomes a dark surface in Dark Mode); for text/icons that must stay
/// white on a coloured background use [onColor].
class AppColors {
  late final BennyColor _bennyColor = BennyStyle.instance.color;

  /// Current mode. Set by the theme controller before each app build.
  Brightness brightness = Brightness.light;

  bool get isDark => brightness == Brightness.dark;

  // ── Dark palette (see docs/design/benny_design_system.html, section 06) ──
  static const _dBg = Color(0xFF0D1722);
  static const _dSurface = Color(0xFF17232F);
  static const _dSurface2 = Color(0xFF1C2B3A);
  static const _dLine = Color(0xFF2A3A47);
  static const _dLine2 = Color(0xFF33485C);
  static const _dLine3 = Color(0xFF3E5567);
  static const _dTx = Color(0xFFE9EEF3);
  static const _dTx2 = Color(0xFF9DB0BF);
  static const _dTx3 = Color(0xFF6E8090);
  static const _dTx4 = Color(0xFFB4C3CF);
  static const _dTx5 = Color(0xFFCBD6DF);
  static const _dTxStrong = Color(0xFFF2F6F9);
  static const _dNavy25 = Color(0xFFEAF1F7);
  static const _dNavy50 = Color(0xFF1E3346);
  static const _dNavy100 = Color(0xFF243C52);
  static const _dNavy300 = Color(0xFF4A6B8C);
  static const _dNavy400 = Color(0xFF8FB6E0);
  static const _dNavy500 = Color(0xFF5E8BB5);
  static const _dNavy600 = Color(0xFF3E6B92);
  static const _dNavy700 = Color(0xFF4F7BA3);
  static const _dShadow = Color(0xFF05101A);
  static const _dAmber = Color(0xFFECB237);
  static const _dAmber300 = Color(0xFFF1C45B);
  static const _dAmberSoft = Color(0xFF362C12);
  static const _dAmberSoft2 = Color(0xFF43360F);
  static const _dOk = Color(0xFF34D17F);
  static const _dOkSoft = Color(0xFF11321F);
  static const _dWarn = Color(0xFFECB237);
  static const _dWarnSoft = Color(0xFF332710);
  static const _dErr = Color(0xFFF2745A);
  static const _dErrSoft = Color(0xFF3A1A14);

  Color _pick(Color light, Color dark) => isDark ? dark : light;

  Color get white => _pick(Colors.white, _dSurface);
  Color get black => Colors.black;
  Color get transparent => Colors.transparent;

  /// Always-white token for text/icons sitting on a coloured (navy/amber)
  /// surface — does NOT flip in Dark Mode.
  Color get onColor => Colors.white;

  /// Semantic surfaces (aliases that read well in feature code).
  Color get surface => white;
  Color get surfaceElevated => _pick(Colors.white, _dSurface2);

  /// Navy hero gradient (splash / home & profile headers). Stays navy in both
  /// modes — just deepens in Dark Mode — so on-navy white text always reads.
  Color get heroTop => _pick(const Color(0xFF1A3C5E), const Color(0xFF1E3E5C));
  Color get heroBottom =>
      _pick(const Color(0xFF0E2234), const Color(0xFF11202E));

  Color get brand25 => _pick(_bennyColor.brand.color25, _dNavy25);
  Color get brand50 => _pick(_bennyColor.brand.color50, _dNavy50);
  Color get brand100 => _pick(_bennyColor.brand.color100, _dNavy100);
  Color get brand200 => _pick(_bennyColor.brand.color200, _dLine2);
  Color get brand300 => _pick(_bennyColor.brand.color300, _dNavy300);
  Color get brand400 => _pick(_bennyColor.brand.color400, _dNavy400);
  Color get brand500 => _pick(_bennyColor.brand.color500, _dNavy500);
  Color get brand600 => _pick(_bennyColor.brand.color600, _dNavy600);
  Color get brand700 => _pick(_bennyColor.brand.color700, _dNavy700);
  Color get brand800 => _pick(_bennyColor.brand.color800, _dTx);
  Color get brand900 => _pick(_bennyColor.brand.color900, _dShadow);

  Color get success25 => _pick(_bennyColor.success.color25, _dOkSoft);
  Color get success50 => _pick(_bennyColor.success.color50, _dOkSoft);
  Color get success100 => _bennyColor.success.color100;
  Color get success200 => _bennyColor.success.color200;
  Color get success300 => _bennyColor.success.color300;
  Color get success400 => _pick(_bennyColor.success.color400, _dOk);
  Color get success500 => _pick(_bennyColor.success.color500, _dOk);
  Color get success600 => _pick(_bennyColor.success.color600, _dOk);
  Color get success700 => _pick(_bennyColor.success.color700, _dOk);
  Color get success800 => _bennyColor.success.color800;
  Color get success900 => _bennyColor.success.color900;

  Color get warning25 => _pick(_bennyColor.warning.color25, _dWarnSoft);
  Color get warning50 => _pick(_bennyColor.warning.color50, _dWarnSoft);
  Color get warning100 => _bennyColor.warning.color100;
  Color get warning200 => _bennyColor.warning.color200;
  Color get warning300 => _bennyColor.warning.color300;
  Color get warning400 => _pick(_bennyColor.warning.color400, _dWarn);
  Color get warning500 => _pick(_bennyColor.warning.color500, _dWarn);
  Color get warning600 => _pick(_bennyColor.warning.color600, _dWarn);
  Color get warning700 => _pick(_bennyColor.warning.color700, _dWarn);
  Color get warning800 => _bennyColor.warning.color800;
  Color get warning900 => _bennyColor.warning.color900;

  Color get secondary25 => _pick(_bennyColor.secondary.color25, _dAmberSoft);
  Color get secondary50 => _pick(_bennyColor.secondary.color50, _dAmberSoft);
  Color get secondary100 => _pick(_bennyColor.secondary.color100, _dAmberSoft2);
  Color get secondary200 => _bennyColor.secondary.color200;
  Color get secondary300 => _pick(_bennyColor.secondary.color300, _dAmber300);
  Color get secondary400 => _pick(_bennyColor.secondary.color400, _dAmber);
  Color get secondary500 => _pick(_bennyColor.secondary.color500, _dAmber);
  Color get secondary600 => _pick(_bennyColor.secondary.color600, _dAmber);
  Color get secondary700 => _pick(_bennyColor.secondary.color700, _dAmber);
  Color get secondary800 => _bennyColor.secondary.color800;
  Color get secondary900 => _bennyColor.secondary.color900;

  Color get error25 => _pick(_bennyColor.error.color25, _dErrSoft);
  Color get error50 => _pick(_bennyColor.error.color50, _dErrSoft);
  Color get error100 => _bennyColor.error.color100;
  Color get error200 => _bennyColor.error.color200;
  Color get error300 => _bennyColor.error.color300;
  Color get error400 => _pick(_bennyColor.error.color400, _dErr);
  Color get error500 => _pick(_bennyColor.error.color500, _dErr);
  Color get error600 => _pick(_bennyColor.error.color600, _dErr);
  Color get error700 => _pick(_bennyColor.error.color700, _dErr);
  Color get error800 => _bennyColor.error.color800;
  Color get error900 => _bennyColor.error.color900;

  Color get neutral00 => white;
  Color get neutral25 => _pick(_bennyColor.neutral.color25, _dBg);
  Color get neutral50 => _pick(_bennyColor.neutral.color50, _dSurface);
  Color get neutral100 => _pick(_bennyColor.neutral.color100, _dLine);
  Color get neutral200 => _pick(_bennyColor.neutral.color200, _dLine2);
  Color get neutral300 => _pick(_bennyColor.neutral.color300, _dLine3);
  Color get neutral400 => _pick(_bennyColor.neutral.color400, _dTx3);
  Color get neutral500 => _pick(_bennyColor.neutral.color500, _dTx2);
  Color get neutral600 => _pick(_bennyColor.neutral.color600, _dTx4);
  Color get neutral700 => _pick(_bennyColor.neutral.color700, _dTx5);
  Color get neutral800 => _pick(_bennyColor.neutral.color800, _dTx);
  Color get neutral900 => _pick(_bennyColor.neutral.color900, _dTxStrong);

  Color get generalBorder => neutral100;

  /// App-wide screen background — gray (#F2F4F7) / dark navy-black (#0D1722).
  Color get surfaceBackground => _pick(const Color(0xFFF2F4F7), _dBg);
}
