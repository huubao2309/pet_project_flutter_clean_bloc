/// Compares dot-separated version strings (e.g. `"2.10.1"`) numerically,
/// segment by segment — so `"2.10.0"` correctly ranks above `"2.9.0"` (string
/// comparison would get this wrong). Missing segments count as 0 (`"2.1"` ==
/// `"2.1.0"`); any build/pre-release suffix after `+` or `-` is ignored.
abstract final class VersionComparator {
  /// Negative if [a] < [b], zero if equal, positive if [a] > [b].
  static int compare(String a, String b) {
    final pa = _parse(a);
    final pb = _parse(b);
    final length = pa.length > pb.length ? pa.length : pb.length;
    for (var i = 0; i < length; i++) {
      final x = i < pa.length ? pa[i] : 0;
      final y = i < pb.length ? pb[i] : 0;
      if (x != y) {
        return x < y ? -1 : 1;
      }
    }
    return 0;
  }

  /// Whether [a] is strictly lower than [b].
  static bool isLower(String a, String b) => compare(a, b) < 0;

  static List<int> _parse(String version) {
    final core = version.split(RegExp(r'[+-]')).first.trim();
    return core
        .split('.')
        .map((segment) => int.tryParse(segment.trim()) ?? 0)
        .toList(growable: false);
  }
}
