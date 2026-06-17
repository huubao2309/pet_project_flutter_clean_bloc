/// Central registry of bundled image/icon asset paths.
///
/// Reference assets through this class (e.g. `BennyImage.logo`) instead of
/// hard-coding strings like `'assets/images/logo_mark.svg'`. If a file is
/// renamed or moved, only the path here changes — every call site stays put.
abstract final class BennyImage {
  static const _base = 'assets/images/';

  /// House-mark logo (white walls + amber roof) for navy backgrounds.
  static const logo = '${_base}logo_mark.svg';

  /// App-icon tile (rounded square house) — used on the welcome landing.
  static const logoTile = '${_base}logo_tile.svg';

  /// House mark for the native launch screen (legacy Android + iOS centre).
  static const splashHouse = '${_base}splash_house.png';

  /// House icon for the Android 12+ native launch screen.
  static const splashLogo = '${_base}splash_logo.png';
}
