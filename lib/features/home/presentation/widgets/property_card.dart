import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_format.dart';
import '../../domain/entities/property_listing.dart';
import 'status_badge.dart';

/// Horizontally-scrolling card summarising one property the collaborator is
/// selling: a navy image banner with a status badge, then price and specs.
class PropertyCard extends StatelessWidget {
  const PropertyCard({required this.listing, this.onTap, super.key});

  final PropertyListing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 232,
        decoration: BoxDecoration(
          color: theme.colors.white,
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
          border: Border.all(color: theme.colors.neutral100),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Banner(listing: listing, theme: theme),
            Padding(
              padding: EdgeInsets.all(theme.spacing.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle.paragraphLabel.copyWith(
                      color: theme.colors.brand800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: theme.colors.neutral400,
                      ),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          listing.address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textStyle.captionDefault
                              .copyWith(color: theme.colors.neutral500),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.spacing8),
                  Text(
                    CurrencyFormat.compactVnd(listing.price),
                    style: theme.textStyle.paragraphLabel.copyWith(
                      color: theme.colors.secondary600,
                      fontWeight: FontWeight.w800,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: theme.spacing.spacing8),
                  Row(
                    children: [
                      _Spec(
                        icon: Icons.crop_square_rounded,
                        label: '${listing.area.toStringAsFixed(0)} m²',
                        theme: theme,
                      ),
                      SizedBox(width: theme.spacing.spacing12),
                      _Spec(
                        icon: Icons.bed_outlined,
                        label: '${listing.bedrooms} PN',
                        theme: theme,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({required this.listing, required this.theme});

  final PropertyListing listing;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(listing.status, theme);

    return SizedBox(
      height: 104,
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.colors.brand400, theme.colors.brand600],
                ),
              ),
              child: Icon(
                Icons.apartment_rounded,
                size: 48,
                color: theme.colors.onColor.withAlpha((255 * 0.35).round()),
              ),
            ),
          ),
          Positioned(
            top: theme.spacing.spacing8,
            left: theme.spacing.spacing8,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.spacing8,
                vertical: theme.spacing.spacing2,
              ),
              decoration: BoxDecoration(
                color: theme.colors.onColor.withAlpha((255 * 0.9).round()),
                borderRadius:
                    BorderRadius.circular(theme.borderRadius.borderRadius16),
              ),
              child: Text(
                listing.type,
                style: theme.textStyle.captionDefault.copyWith(
                  color: theme.colors.brand700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            top: theme.spacing.spacing8,
            right: theme.spacing.spacing8,
            child: StatusBadge(
              label: status.label,
              color: status.color,
              background: status.background,
            ),
          ),
        ],
      ),
    );
  }
}

class _Spec extends StatelessWidget {
  const _Spec({required this.icon, required this.label, required this.theme});

  final IconData icon;
  final String label;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: theme.colors.neutral400),
        const SizedBox(width: 3),
        Text(
          label,
          style: theme.textStyle.captionDefault
              .copyWith(color: theme.colors.neutral600),
        ),
      ],
    );
  }
}

class _StatusStyle {
  const _StatusStyle(this.label, this.color, this.background);
  final String label;
  final Color color;
  final Color background;
}

_StatusStyle _statusStyle(PropertyStatus status, ThemeState theme) {
  switch (status) {
    case PropertyStatus.available:
      return _StatusStyle(
        'property.status.available'.tr(),
        theme.colors.success700,
        theme.colors.success50,
      );
    case PropertyStatus.deposited:
      return _StatusStyle(
        'property.status.deposited'.tr(),
        theme.colors.secondary700,
        theme.colors.secondary50,
      );
    case PropertyStatus.sold:
      return _StatusStyle(
        'property.status.sold'.tr(),
        theme.colors.neutral600,
        theme.colors.neutral100,
      );
  }
}
