import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/commission_filter.dart';

/// Horizontal quick-sort chips plus a "filter" chip that opens the full filter
/// sheet. Tapping a sort chip applies that ordering immediately.
class CommissionSortBar extends StatelessWidget {
  const CommissionSortBar({
    required this.filter,
    required this.onSortSelected,
    required this.onOpenFilter,
    super.key,
  });

  final CommissionFilter filter;
  final ValueChanged<CommissionSort> onSortSelected;
  final VoidCallback onOpenFilter;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return SizedBox(
      height: 34,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _SortChip(
            label: 'commission.sort.score_short'.tr(),
            icon: Icons.arrow_downward_rounded,
            selected: filter.sort == CommissionSort.score,
            onTap: () => onSortSelected(CommissionSort.score),
            theme: theme,
          ),
          SizedBox(width: theme.spacing.spacing8),
          _SortChip(
            label: 'commission.sort.price_short'.tr(),
            selected: filter.sort == CommissionSort.priceDesc ||
                filter.sort == CommissionSort.priceAsc,
            onTap: () => onSortSelected(CommissionSort.priceDesc),
            theme: theme,
          ),
          SizedBox(width: theme.spacing.spacing8),
          _SortChip(
            label: 'commission.sort.nearest_short'.tr(),
            selected: filter.sort == CommissionSort.nearest,
            onTap: () => onSortSelected(CommissionSort.nearest),
            theme: theme,
          ),
          SizedBox(width: theme.spacing.spacing8),
          _FilterChip(
            active: filter.hasStatusFilter,
            onTap: onOpenFilter,
            theme: theme,
          ),
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeState theme;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? theme.colors.secondary500 : theme.colors.white;
    final fg = selected ? theme.colors.onColor : theme.colors.brand700;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing12),
        decoration: BoxDecoration(
          color: bg,
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
          border: Border.all(
            color:
                selected ? theme.colors.secondary500 : theme.colors.neutral200,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: fg),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: theme.textStyle.captionDefault
                  .copyWith(color: fg, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.active,
    required this.onTap,
    required this.theme,
  });

  final bool active;
  final VoidCallback onTap;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing12),
        decoration: BoxDecoration(
          color: theme.colors.white,
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
          border: Border.all(
            color: active ? theme.colors.brand600 : theme.colors.neutral200,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.tune_rounded,
              size: 14,
              color: active ? theme.colors.brand700 : theme.colors.brand600,
            ),
            const SizedBox(width: 4),
            Text(
              'commission.filter'.tr(),
              style: theme.textStyle.captionDefault.copyWith(
                color: theme.colors.brand700,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
