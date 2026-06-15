/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart' as _svg;
import 'package:vector_graphics/vector_graphics.dart' as _vg;

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/ic_check.svg
  SvgGenImage get icCheck => const SvgGenImage('assets/svg/ic_check.svg');

  /// File path: assets/svg/ic_check_small.svg
  SvgGenImage get icCheckSmall =>
      const SvgGenImage('assets/svg/ic_check_small.svg');

  /// File path: assets/svg/ic_close_small.svg
  SvgGenImage get icCloseSmall =>
      const SvgGenImage('assets/svg/ic_close_small.svg');

  /// File path: assets/svg/ic_direction_left.svg
  SvgGenImage get icDirectionLeft =>
      const SvgGenImage('assets/svg/ic_direction_left.svg');

  /// File path: assets/svg/ic_error.svg
  SvgGenImage get icError => const SvgGenImage('assets/svg/ic_error.svg');

  /// File path: assets/svg/ic_eye_close.svg
  SvgGenImage get icEyeClose =>
      const SvgGenImage('assets/svg/ic_eye_close.svg');

  /// File path: assets/svg/ic_eye_open.svg
  SvgGenImage get icEyeOpen => const SvgGenImage('assets/svg/ic_eye_open.svg');

  /// File path: assets/svg/ic_info.svg
  SvgGenImage get icInfo => const SvgGenImage('assets/svg/ic_info.svg');

  /// File path: assets/svg/ic_invalid.svg
  SvgGenImage get icInvalid => const SvgGenImage('assets/svg/ic_invalid.svg');

  /// File path: assets/svg/ic_lock.svg
  SvgGenImage get icLock => const SvgGenImage('assets/svg/ic_lock.svg');

  /// File path: assets/svg/ic_magic.svg
  SvgGenImage get icMagic => const SvgGenImage('assets/svg/ic_magic.svg');

  /// File path: assets/svg/ic_minus_small.svg
  SvgGenImage get icMinusSmall =>
      const SvgGenImage('assets/svg/ic_minus_small.svg');

  /// File path: assets/svg/ic_search.svg
  SvgGenImage get icSearch => const SvgGenImage('assets/svg/ic_search.svg');

  /// File path: assets/svg/ic_trash.svg
  SvgGenImage get icTrash => const SvgGenImage('assets/svg/ic_trash.svg');

  /// File path: assets/svg/ic_triangle_bottom.svg
  SvgGenImage get icTriangleBottom =>
      const SvgGenImage('assets/svg/ic_triangle_bottom.svg');

  /// File path: assets/svg/ic_triangle_left.svg
  SvgGenImage get icTriangleLeft =>
      const SvgGenImage('assets/svg/ic_triangle_left.svg');

  /// File path: assets/svg/ic_triangle_right.svg
  SvgGenImage get icTriangleRight =>
      const SvgGenImage('assets/svg/ic_triangle_right.svg');

  /// File path: assets/svg/ic_triangle_top.svg
  SvgGenImage get icTriangleTop =>
      const SvgGenImage('assets/svg/ic_triangle_top.svg');

  /// File path: assets/svg/ic_valid.svg
  SvgGenImage get icValid => const SvgGenImage('assets/svg/ic_valid.svg');

  /// Directory path: packages/benny_style/assets/svg
  String get path => 'packages/benny_style/assets/svg';

  /// List of all assets
  List<SvgGenImage> get values => [
    icCheck,
    icCheckSmall,
    icCloseSmall,
    icDirectionLeft,
    icError,
    icEyeClose,
    icEyeOpen,
    icInfo,
    icInvalid,
    icLock,
    icMagic,
    icMinusSmall,
    icSearch,
    icTrash,
    icTriangleBottom,
    icTriangleLeft,
    icTriangleRight,
    icTriangleTop,
    icValid,
  ];
}

class Assets {
  const Assets._();

  static const String package = 'benny_style';

  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class SvgGenImage {
  const SvgGenImage(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = false;

  const SvgGenImage.vec(this._assetName, {this.size, this.flavors = const {}})
    : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  static const String package = 'benny_style';

  _svg.SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    @Deprecated('Do not specify package for a generated library asset')
    String? package = package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    _svg.SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final _svg.BytesLoader loader;
    if (_isVecFormat) {
      loader = _vg.AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = _svg.SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return _svg.SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter:
          colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => 'packages/benny_style/$_assetName';
}
