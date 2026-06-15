import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:shimmer/shimmer.dart';
import 'package:benny_style/theme/theme_state.dart';

Widget shimmer({
  double? width,
  double? height,
  BoxDecoration? decoration,
  Color? color,
  Color? baseColor,
  Color? highlightColor,
  Widget? child,
  EdgeInsets? margin,
}) {
  final colors = bennyLocator<ThemeState>().colors;
  return Container(
    margin: margin,
    child: Shimmer.fromColors(
      baseColor: baseColor ?? colors.neutral200,
      highlightColor: highlightColor ?? colors.neutral200,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        color: decoration != null ? null : (color ?? colors.white),
        decoration: decoration,
        child: child,
      ),
    ),
  );
}

Widget shimmerCircle({
  required double height,
  required double width,
  Color? baseColor,
  Color? highlightColor,
}) {
  final colors = bennyLocator<ThemeState>().colors;
  return Shimmer.fromColors(
    baseColor: baseColor ?? colors.neutral200,
    highlightColor: highlightColor ?? colors.neutral200,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    ),
  );
}
