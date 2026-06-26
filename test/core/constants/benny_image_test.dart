import 'package:flutter_test/flutter_test.dart';
import 'package:pet_project_flutter_clean_bloc/core/constants/benny_image.dart';

void main() {
  test('every asset path lives under assets/images/', () {
    final paths = <String>[
      BennyImage.logo,
      BennyImage.logoTile,
      BennyImage.splashHouse,
      BennyImage.splashLogo,
    ];
    for (final path in paths) {
      expect(path, startsWith('assets/images/'), reason: path);
    }
  });

  test('svg marks and png splashes use the expected extensions', () {
    expect(BennyImage.logo, endsWith('.svg'));
    expect(BennyImage.logoTile, endsWith('.svg'));
    expect(BennyImage.splashHouse, endsWith('.png'));
    expect(BennyImage.splashLogo, endsWith('.png'));
  });

  test('paths are unique', () {
    final paths = <String>[
      BennyImage.logo,
      BennyImage.logoTile,
      BennyImage.splashHouse,
      BennyImage.splashLogo,
    ];
    expect(paths.toSet().length, paths.length);
  });
}
