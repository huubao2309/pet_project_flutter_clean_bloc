import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../domain/entities/commission_filter.dart';
import '../../domain/entities/commission_listing.dart';

/// Shows the sort + status filter bottom sheet, returning the chosen
/// [CommissionFilter] when the user taps "Apply", or null if dismissed.
Future<CommissionFilter?> showCommissionFilterSheet(
  BuildContext context,
  CommissionFilter current,
) {
  final theme = getIt<ThemeState>();
  return showModalBottomSheet<CommissionFilter>(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _CommissionFilterSheet(initial: current),
  );
}

class _CommissionFilterSheet extends StatefulWidget {
  const _CommissionFilterSheet({required this.initial});

  final CommissionFilter initial;

  @override
  State<_CommissionFilterSheet> createState() => _CommissionFilterSheetState();
}

class _CommissionFilterSheetState extends State<_CommissionFilterSheet> {
  late CommissionFilter _draft = widget.initial;

  static const _sortOptions = <CommissionSort, String>{
    CommissionSort.score: 'commission.sort.score',
    CommissionSort.priceDesc: 'commission.sort.price_desc',
    CommissionSort.priceAsc: 'commission.sort.price_asc',
    CommissionSort.nearest: 'commission.sort.nearest',
  };

  static const _statusOptions = <CommissionStatus, String>{
    CommissionStatus.urgentSell: 'commission.status.urgent_sell',
    CommissionStatus.available: 'commission.status.available',
    CommissionStatus.deposited: 'commission.status.deposited',
  };

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          theme.spacing.spacing16,
          theme.spacing.spacing12,
          theme.spacing.spacing16,
          theme.spacing.spacing20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colors.neutral200,
                  borderRadius:
                      BorderRadius.circular(theme.borderRadius.borderRadius4),
                ),
              ),
            ),
            SizedBox(height: theme.spacing.spacing16),
            Text(
              'commission.filter_title'.tr(),
              style: theme.textStyle.heading
                  .copyWith(color: theme.colors.brand800),
            ),
            SizedBox(height: theme.spacing.spacing16),
            _GroupLabel(text: 'commission.sort_label'.tr(), theme: theme),
            for (final entry in _sortOptions.entries)
              _SortRow(
                label: entry.value.tr(),
                selected: _draft.sort == entry.key,
                onTap: () => setState(
                  () => _draft = _draft.copyWith(sort: entry.key),
                ),
                theme: theme,
              ),
            SizedBox(height: theme.spacing.spacing16),
            _GroupLabel(text: 'commission.status_label'.tr(), theme: theme),
            SizedBox(height: theme.spacing.spacing8),
            Wrap(
              spacing: theme.spacing.spacing8,
              runSpacing: theme.spacing.spacing8,
              children: [
                for (final entry in _statusOptions.entries)
                  _StatusChip(
                    label: entry.value.tr(),
                    selected: _draft.statuses.contains(entry.key),
                    onTap: () => setState(
                      () => _draft = _draft.toggleStatus(entry.key),
                    ),
                    theme: theme,
                  ),
              ],
            ),
            SizedBox(height: theme.spacing.spacing24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(
                      () => _draft = const CommissionFilter(),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colors.brand600,
                      side: BorderSide(color: theme.colors.brand200),
                      padding: EdgeInsets.symmetric(
                        vertical: theme.spacing.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          theme.borderRadius.borderRadius8,
                        ),
                      ),
                    ),
                    child: Text('commission.reset'.tr()),
                  ),
                ),
                SizedBox(width: theme.spacing.spacing12),
                Expanded(
                  flex: 2,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(_draft),
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colors.brand600,
                      padding: EdgeInsets.symmetric(
                        vertical: theme.spacing.spacing12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          theme.borderRadius.borderRadius8,
                        ),
                      ),
                    ),
                    child: Text('commission.apply'.tr()),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel({required this.text, required this.theme});

  final String text;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: theme.textStyle.captionDefault.copyWith(
        color: theme.colors.neutral400,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _SortRow extends StatelessWidget {
  const _SortRow({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: theme.spacing.spacing12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textStyle.paragraphDefault.copyWith(
                color: selected ? theme.colors.brand800 : theme.colors.brand700,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: selected
                  ? theme.colors.secondary500
                  : theme.colors.neutral300,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacing.spacing12,
          vertical: theme.spacing.spacing8,
        ),
        decoration: BoxDecoration(
          color: selected ? theme.colors.brand600 : theme.colors.white,
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius16),
          border: Border.all(
            color: selected ? theme.colors.brand600 : theme.colors.neutral200,
          ),
        ),
        child: Text(
          label,
          style: theme.textStyle.captionDefault.copyWith(
            color: selected ? theme.colors.onColor : theme.colors.brand700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
