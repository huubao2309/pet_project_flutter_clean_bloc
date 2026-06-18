import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Navy banner summarising the resolved location, search radius and tip count.
/// Tapping the trailing refresh icon re-resolves the current position.
class CommissionLocationBanner extends StatelessWidget {
  const CommissionLocationBanner({
    required this.locationLabel,
    required this.radiusKm,
    required this.count,
    this.onRefresh,
    super.key,
  });

  final String locationLabel;
  final double radiusKm;
  final int count;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final radiusLabel = radiusKm.toStringAsFixed(0);

    return Container(
      padding: EdgeInsets.all(theme.spacing.spacing12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colors.brand600, theme.colors.brand800],
        ),
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: theme.colors.secondary500.withAlpha((255 * 0.22).round()),
              borderRadius:
                  BorderRadius.circular(theme.borderRadius.borderRadius8),
            ),
            child: Icon(Icons.place_outlined,
                size: 18, color: theme.colors.secondary300,),
          ),
          SizedBox(width: theme.spacing.spacing8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'commission.banner_title'.tr(),
                  style: theme.textStyle.captionDefault.copyWith(
                    color: theme.colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  'commission.banner_subtitle'.tr(
                    namedArgs: {
                      'location': locationLabel,
                      'radius': radiusLabel,
                      'count': '$count',
                    },
                  ),
                  style: theme.textStyle.captionDefault
                      .copyWith(color: theme.colors.brand100),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onRefresh,
            visualDensity: VisualDensity.compact,
            icon: Icon(Icons.refresh_rounded, color: theme.colors.brand100),
          ),
        ],
      ),
    );
  }
}
