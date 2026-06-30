import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_format.dart';
import '../../../home/presentation/widgets/status_badge.dart';
import '../../domain/entities/commission_listing.dart';

/// One row in the Commission feed: a property thumbnail next to its title,
/// distance, price, commission payout and status, plus an "expiring soon"
/// warning when the listing is about to lapse.
class CommissionCard extends StatelessWidget {
  const CommissionCard({required this.listing, this.onTap, super.key});

  final CommissionListing listing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final status = _statusStyle(listing.status, theme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(theme.spacing.spacing12),
        decoration: BoxDecoration(
          color: theme.colors.white,
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
          border: Border.all(color: theme.colors.neutral100),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumbnail(theme: theme),
            SizedBox(width: theme.spacing.spacing12),
            Expanded(child: _Details(listing: listing, status: status)),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      height: 66,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colors.brand400, theme.colors.brand600],
        ),
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius8),
      ),
      child: Icon(
        Icons.apartment_rounded,
        color: theme.colors.onColor.withAlpha((255 * 0.4).round()),
        size: 30,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.listing, required this.status});

  final CommissionListing listing;
  final _StatusStyle status;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                listing.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyle.paragraphLabel.copyWith(
                  color: theme.colors.brand800,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(width: theme.spacing.spacing8),
            StatusBadge(
              label: status.label,
              color: status.color,
              background: status.background,
              icon: status.icon,
            ),
          ],
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
                'commission.distance'.tr(
                  namedArgs: {
                    'address': listing.address,
                    'distance': _formatDistance(listing.distanceKm),
                  },
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyle.captionDefault
                    .copyWith(color: theme.colors.neutral500),
              ),
            ),
          ],
        ),
        SizedBox(height: theme.spacing.spacing8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              CurrencyFormat.compactVnd(listing.price),
              style: theme.textStyle.paragraphLabel.copyWith(
                color: theme.colors.secondary600,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
            _CommissionPill(listing: listing, theme: theme),
          ],
        ),
        if (listing.isExpiringSoon) ...[
          SizedBox(height: theme.spacing.spacing8),
          _ExpiryTag(days: listing.expiresInDays!, theme: theme),
        ],
      ],
    );
  }
}

class _CommissionPill extends StatelessWidget {
  const _CommissionPill({required this.listing, required this.theme});

  final CommissionListing listing;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    final percent =
        (listing.commissionRate * 100).toStringAsFixed(1).replaceAll('.', ',');
    final amount = CurrencyFormat.compactVnd(listing.commissionAmount);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing8,
        vertical: theme.spacing.spacing2,
      ),
      decoration: BoxDecoration(
        color: theme.colors.secondary50,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on_outlined,
            size: 13,
            color: theme.colors.secondary700,
          ),
          const SizedBox(width: 3),
          Text(
            'commission.payout'
                .tr(namedArgs: {'percent': percent, 'amount': amount}),
            style: theme.textStyle.captionDefault.copyWith(
              color: theme.colors.secondary700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpiryTag extends StatelessWidget {
  const _ExpiryTag({required this.days, required this.theme});

  final int days;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing8,
        vertical: theme.spacing.spacing2,
      ),
      decoration: BoxDecoration(
        color: theme.colors.warning50,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 13,
            color: theme.colors.warning700,
          ),
          const SizedBox(width: 4),
          Text(
            'commission.expiring'.tr(namedArgs: {'days': '$days'}),
            style: theme.textStyle.captionDefault.copyWith(
              color: theme.colors.warning700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _formatDistance(double km) {
  final value = km.toStringAsFixed(1).replaceAll('.', ',');
  return '$value km';
}

class _StatusStyle {
  const _StatusStyle(this.label, this.color, this.background, {this.icon});
  final String label;
  final Color color;
  final Color background;
  final IconData? icon;
}

_StatusStyle _statusStyle(CommissionStatus status, ThemeState theme) {
  switch (status) {
    case CommissionStatus.urgentSell:
      return _StatusStyle(
        'commission.status.urgent_sell'.tr(),
        theme.colors.error700,
        theme.colors.error50,
        icon: Icons.local_fire_department_rounded,
      );
    case CommissionStatus.available:
      return _StatusStyle(
        'commission.status.available'.tr(),
        theme.colors.success700,
        theme.colors.success50,
      );
    case CommissionStatus.deposited:
      return _StatusStyle(
        'commission.status.deposited'.tr(),
        theme.colors.secondary700,
        theme.colors.secondary50,
      );
  }
}
