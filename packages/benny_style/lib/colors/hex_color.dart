import "dart:ui";

class HexColor extends Color {
  static int _getColorFromHex(String hex) {
    if (hex.isEmpty) {
      return 0;
    }

    var hexColor = hex;
    hexColor = hexColor.toUpperCase().replaceAll("#", "");

    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    } else if (hexColor.length == 8) {
      final alpha = hexColor.substring(6);
      final color = hexColor.substring(0, 6);
      hexColor = "$alpha$color";
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}
