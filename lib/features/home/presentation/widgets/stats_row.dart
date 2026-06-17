import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';

/// Two-up pipeline stats: active listings and potential customers.
class StatsRow extends StatelessWidget {
  const StatsRow({
    required this.activeListings,
    required this.potentialCustomers,
    super.key,
  });

  final int activeListings;
  final int potentialCustomers;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            labelKey: 'home.active_listings',
            value: '$activeListings',
            icon: Icons.maps_home_work_outlined,
            theme: theme,
          ),
        ),
        SizedBox(width: theme.spacing.spacing12),
        Expanded(
          child: _StatCard(
            labelKey: 'home.potential_customers',
            value: '$potentialCustomers',
            icon: Icons.person_search_outlined,
            theme: theme,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.labelKey,
    required this.value,
    required this.icon,
    required this.theme,
  });

  final String labelKey;
  final String value;
  final IconData icon;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(theme.spacing.spacing16),
      decoration: BoxDecoration(
        color: theme.colors.white,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
        border: Border.all(color: theme.colors.neutral100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colors.brand500, size: 22),
          SizedBox(height: theme.spacing.spacing12),
          Text(
            value,
            style: theme.textStyle.heading.copyWith(
              color: theme.colors.brand800,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            labelKey.tr(),
            style: theme.textStyle.captionDefault
                .copyWith(color: theme.colors.neutral500),
          ),
        ],
      ),
    );
  }
}
