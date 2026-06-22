import "package:flutter/material.dart";
import 'package:benny_style/colors/benny_color.dart';
import 'package:benny_style/benny_style.dart';

/// App colour tokens. Feature code and benny_style components read these getters
/// instead of hardcoding colours, so the palette can be tuned in one place.
///
/// `white` is the card/surface token; for text/icons that must stay white on a
/// coloured background use [onColor].
class AppColors {
  late final BennyColor _bennyColor = BennyStyle.instance.color;

  Color get white => Colors.white;
  Color get black => Colors.black;
  Color get transparent => Colors.transparent;

  /// Always-white token for text/icons sitting on a coloured (navy/amber)
  /// surface.
  Color get onColor => Colors.white;

  /// Semantic surfaces (aliases that read well in feature code).
  Color get surface => white;
  Color get surfaceElevated => Colors.white;

  /// Navy hero gradient (splash / home & profile headers); on-navy white text
  /// always reads against it.
  Color get heroTop => const Color(0xFF1A3C5E);
  Color get heroBottom => const Color(0xFF0E2234);

  Color get brand25 => _bennyColor.brand.color25;
  Color get brand50 => _bennyColor.brand.color50;
  Color get brand100 => _bennyColor.brand.color100;
  Color get brand200 => _bennyColor.brand.color200;
  Color get brand300 => _bennyColor.brand.color300;
  Color get brand400 => _bennyColor.brand.color400;
  Color get brand500 => _bennyColor.brand.color500;
  Color get brand600 => _bennyColor.brand.color600;
  Color get brand700 => _bennyColor.brand.color700;
  Color get brand800 => _bennyColor.brand.color800;
  Color get brand900 => _bennyColor.brand.color900;

  Color get success25 => _bennyColor.success.color25;
  Color get success50 => _bennyColor.success.color50;
  Color get success100 => _bennyColor.success.color100;
  Color get success200 => _bennyColor.success.color200;
  Color get success300 => _bennyColor.success.color300;
  Color get success400 => _bennyColor.success.color400;
  Color get success500 => _bennyColor.success.color500;
  Color get success600 => _bennyColor.success.color600;
  Color get success700 => _bennyColor.success.color700;
  Color get success800 => _bennyColor.success.color800;
  Color get success900 => _bennyColor.success.color900;

  Color get warning25 => _bennyColor.warning.color25;
  Color get warning50 => _bennyColor.warning.color50;
  Color get warning100 => _bennyColor.warning.color100;
  Color get warning200 => _bennyColor.warning.color200;
  Color get warning300 => _bennyColor.warning.color300;
  Color get warning400 => _bennyColor.warning.color400;
  Color get warning500 => _bennyColor.warning.color500;
  Color get warning600 => _bennyColor.warning.color600;
  Color get warning700 => _bennyColor.warning.color700;
  Color get warning800 => _bennyColor.warning.color800;
  Color get warning900 => _bennyColor.warning.color900;

  Color get secondary25 => _bennyColor.secondary.color25;
  Color get secondary50 => _bennyColor.secondary.color50;
  Color get secondary100 => _bennyColor.secondary.color100;
  Color get secondary200 => _bennyColor.secondary.color200;
  Color get secondary300 => _bennyColor.secondary.color300;
  Color get secondary400 => _bennyColor.secondary.color400;
  Color get secondary500 => _bennyColor.secondary.color500;
  Color get secondary600 => _bennyColor.secondary.color600;
  Color get secondary700 => _bennyColor.secondary.color700;
  Color get secondary800 => _bennyColor.secondary.color800;
  Color get secondary900 => _bennyColor.secondary.color900;

  Color get error25 => _bennyColor.error.color25;
  Color get error50 => _bennyColor.error.color50;
  Color get error100 => _bennyColor.error.color100;
  Color get error200 => _bennyColor.error.color200;
  Color get error300 => _bennyColor.error.color300;
  Color get error400 => _bennyColor.error.color400;
  Color get error500 => _bennyColor.error.color500;
  Color get error600 => _bennyColor.error.color600;
  Color get error700 => _bennyColor.error.color700;
  Color get error800 => _bennyColor.error.color800;
  Color get error900 => _bennyColor.error.color900;

  Color get neutral00 => white;
  Color get neutral25 => _bennyColor.neutral.color25;
  Color get neutral50 => _bennyColor.neutral.color50;
  Color get neutral100 => _bennyColor.neutral.color100;
  Color get neutral200 => _bennyColor.neutral.color200;
  Color get neutral300 => _bennyColor.neutral.color300;
  Color get neutral400 => _bennyColor.neutral.color400;
  Color get neutral500 => _bennyColor.neutral.color500;
  Color get neutral600 => _bennyColor.neutral.color600;
  Color get neutral700 => _bennyColor.neutral.color700;
  Color get neutral800 => _bennyColor.neutral.color800;
  Color get neutral900 => _bennyColor.neutral.color900;

  Color get generalBorder => neutral100;

  /// App-wide screen background — gray (#F2F4F7).
  Color get surfaceBackground => const Color(0xFFF2F4F7);
}
