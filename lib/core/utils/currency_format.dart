/// Vietnamese currency formatting helpers shared across features.
///
/// Real-estate figures are large, so the dashboard prefers a compact form
/// ("1,2 tỷ", "950 tr") while keeping a full grouped form available.
abstract final class CurrencyFormat {
  /// Compact VND, e.g. 1_200_000_000 -> "1,2 tỷ", 12_500_000 -> "12,5 tr".
  static String compactVnd(num amount) {
    if (amount >= 1000000000) {
      return '${_trim(amount / 1000000000)} tỷ';
    }
    if (amount >= 1000000) {
      return '${_trim(amount / 1000000)} tr';
    }
    if (amount >= 1000) {
      return '${_trim(amount / 1000)} k';
    }
    return amount.toStringAsFixed(0);
  }

  /// Full grouped VND, e.g. 12_500_000 -> "12.500.000 ₫".
  static String fullVnd(num amount) {
    final digits = amount.round().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(digits[i]);
    }
    return '$buffer ₫';
  }

  /// One decimal place, dropping a trailing ",0" and using a comma separator.
  static String _trim(double value) {
    final fixed = value.toStringAsFixed(1);
    final normalized =
        fixed.endsWith('.0') ? fixed.substring(0, fixed.length - 2) : fixed;
    return normalized.replaceAll('.', ',');
  }
}
