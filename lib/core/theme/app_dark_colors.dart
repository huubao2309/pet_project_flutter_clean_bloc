import 'package:benny_style/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Dark Mode colour configuration — lives in the app's `core` layer (NOT in the
/// `benny_style` package). It subclasses the package's light [AppColors] and
/// overrides only the tokens that differ in Dark Mode; everything else (e.g.
/// `onColor`, the brand/success ramps that stay the same) is inherited.
///
/// Switching mode swaps the [ThemeState.colors] instance between [AppColors]
/// (light) and this class (dark), so feature code and benny_style components —
/// which all read `theme.colors.*` — flip automatically on rebuild.
///
/// Palette mirrors `docs/design/benny_design_system.html`, section
/// "06 · Screens — Dark Mode".
class AppDarkColors extends AppColors {
  // ── Dark palette primitives ──────────────────────────────────────────────
  static const _bg = Color(0xFF0D1722);
  static const _surface = Color(0xFF17232F);
  static const _surface2 = Color(0xFF1C2B3A);
  static const _line = Color(0xFF2A3A47);
  static const _line2 = Color(0xFF33485C);
  static const _line3 = Color(0xFF3E5567);
  static const _tx = Color(0xFFE9EEF3);
  static const _tx2 = Color(0xFF9DB0BF);
  static const _tx3 = Color(0xFF6E8090);
  static const _tx4 = Color(0xFFB4C3CF);
  static const _tx5 = Color(0xFFCBD6DF);
  static const _txStrong = Color(0xFFF2F6F9);
  static const _navy25 = Color(0xFFEAF1F7);
  static const _navy50 = Color(0xFF1E3346);
  static const _navy100 = Color(0xFF243C52);
  static const _navy300 = Color(0xFF4A6B8C);
  static const _navy400 = Color(0xFF8FB6E0);
  static const _navy500 = Color(0xFF5E8BB5);
  static const _navy600 = Color(0xFF3E6B92);
  static const _navy700 = Color(0xFF4F7BA3);
  static const _shadow = Color(0xFF05101A);
  static const _amber = Color(0xFFECB237);
  static const _amber300 = Color(0xFFF1C45B);
  static const _amberSoft = Color(0xFF362C12);
  static const _amberSoft2 = Color(0xFF43360F);
  static const _ok = Color(0xFF34D17F);
  static const _okSoft = Color(0xFF11321F);
  static const _warn = Color(0xFFECB237);
  static const _warnSoft = Color(0xFF332710);
  static const _err = Color(0xFFF2745A);
  static const _errSoft = Color(0xFF3A1A14);

  // ── Surfaces ──────────────────────────────────────────────────────────────
  @override
  Color get white => _surface;
  @override
  Color get surfaceElevated => _surface2;
  @override
  Color get surfaceBackground => _bg;

  // Navy hero gradient — stays navy (just deepens) so on-navy white text reads.
  @override
  Color get heroTop => const Color(0xFF1E3E5C);
  @override
  Color get heroBottom => const Color(0xFF11202E);

  // ── Brand (navy) ramp ───────────────────────────────────────────────────
  @override
  Color get brand25 => _navy25;
  @override
  Color get brand50 => _navy50;
  @override
  Color get brand100 => _navy100;
  @override
  Color get brand200 => _line2;
  @override
  Color get brand300 => _navy300;
  @override
  Color get brand400 => _navy400;
  @override
  Color get brand500 => _navy500;
  @override
  Color get brand600 => _navy600;
  @override
  Color get brand700 => _navy700;
  @override
  Color get brand800 => _tx;
  @override
  Color get brand900 => _shadow;

  // ── Success ───────────────────────────────────────────────────────────────
  @override
  Color get success25 => _okSoft;
  @override
  Color get success50 => _okSoft;
  @override
  Color get success400 => _ok;
  @override
  Color get success500 => _ok;
  @override
  Color get success600 => _ok;
  @override
  Color get success700 => _ok;

  // ── Warning ───────────────────────────────────────────────────────────────
  @override
  Color get warning25 => _warnSoft;
  @override
  Color get warning50 => _warnSoft;
  @override
  Color get warning400 => _warn;
  @override
  Color get warning500 => _warn;
  @override
  Color get warning600 => _warn;
  @override
  Color get warning700 => _warn;

  // ── Secondary (amber) ──────────────────────────────────────────────────────
  @override
  Color get secondary25 => _amberSoft;
  @override
  Color get secondary50 => _amberSoft;
  @override
  Color get secondary100 => _amberSoft2;
  @override
  Color get secondary300 => _amber300;
  @override
  Color get secondary400 => _amber;
  @override
  Color get secondary500 => _amber;
  @override
  Color get secondary600 => _amber;
  @override
  Color get secondary700 => _amber;

  // ── Error ─────────────────────────────────────────────────────────────────
  @override
  Color get error25 => _errSoft;
  @override
  Color get error50 => _errSoft;
  @override
  Color get error400 => _err;
  @override
  Color get error500 => _err;
  @override
  Color get error600 => _err;
  @override
  Color get error700 => _err;

  // ── Neutral (surfaces, borders, text) ──────────────────────────────────────
  @override
  Color get neutral25 => _bg;
  @override
  Color get neutral50 => _surface;
  @override
  Color get neutral100 => _line;
  @override
  Color get neutral200 => _line2;
  @override
  Color get neutral300 => _line3;
  @override
  Color get neutral400 => _tx3;
  @override
  Color get neutral500 => _tx2;
  @override
  Color get neutral600 => _tx4;
  @override
  Color get neutral700 => _tx5;
  @override
  Color get neutral800 => _tx;
  @override
  Color get neutral900 => _txStrong;
}
