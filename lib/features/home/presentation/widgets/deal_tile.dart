import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_format.dart';
import '../../domain/entities/deal_record.dart';
import 'status_badge.dart';

/// One row in the recent buy/sell history: property + customer on the left,
/// the collaborator's commission and a status badge on the right.
class DealTile extends StatelessWidget {
  const DealTile({required this.deal, this.onTap, super.key});

  final DealRecord deal;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final status = _statusStyle(deal.status, theme);

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
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: theme.colors.brand50,
                borderRadius:
                    BorderRadius.circular(theme.borderRadius.borderRadius8),
              ),
              child: Icon(
                Icons.home_work_outlined,
                color: theme.colors.brand600,
                size: 22,
              ),
            ),
            SizedBox(width: theme.spacing.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    deal.propertyTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle.paragraphLabel.copyWith(
                      color: theme.colors.brand800,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'home.deal_subtitle'.tr(
                      namedArgs: {
                        'customer': deal.customerName,
                        'date': deal.dateLabel,
                      },
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textStyle.captionDefault
                        .copyWith(color: theme.colors.neutral500),
                  ),
                ],
              ),
            ),
            SizedBox(width: theme.spacing.spacing8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '+${CurrencyFormat.compactVnd(deal.commission)}',
                  style: theme.textStyle.paragraphLabel.copyWith(
                    color: theme.colors.success600,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                StatusBadge(
                  label: status.label,
                  color: status.color,
                  background: status.background,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusStyle {
  const _StatusStyle(this.label, this.color, this.background);
  final String label;
  final Color color;
  final Color background;
}

_StatusStyle _statusStyle(DealStatus status, ThemeState theme) {
  switch (status) {
    case DealStatus.completed:
      return _StatusStyle(
        'deal.status.completed'.tr(),
        theme.colors.success700,
        theme.colors.success50,
      );
    case DealStatus.deposited:
      return _StatusStyle(
        'deal.status.deposited'.tr(),
        theme.colors.secondary700,
        theme.colors.secondary50,
      );
    case DealStatus.cancelled:
      return _StatusStyle(
        'deal.status.cancelled'.tr(),
        theme.colors.error600,
        theme.colors.error50,
      );
  }
}
