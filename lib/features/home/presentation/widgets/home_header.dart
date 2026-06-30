import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_format.dart';

/// Navy gradient hero at the top of the home dashboard: greeting + avatar +
/// notifications, with an overlapping white commission summary card.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.agentName,
    required this.monthlyCommission,
    required this.pendingCommission,
    required this.dealsClosed,
    super.key,
  });

  final String agentName;
  final double monthlyCommission;
  final double pendingCommission;
  final int dealsClosed;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.colors.heroTop, theme.colors.heroBottom],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        theme.spacing.spacing20,
        theme.spacing.spacing12,
        theme.spacing.spacing20,
        theme.spacing.spacing24,
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _GreetingRow(agentName: agentName, theme: theme),
            SizedBox(height: theme.spacing.spacing20),
            _CommissionCard(
              monthlyCommission: monthlyCommission,
              pendingCommission: pendingCommission,
              dealsClosed: dealsClosed,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  const _GreetingRow({required this.agentName, required this.theme});

  final String agentName;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    final words = agentName.trim().split(RegExp(r'\s+'));
    final lastWord = words.isEmpty ? '' : words.last;
    final initials = lastWord.isEmpty ? '?' : lastWord.characters.first;

    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: theme.colors.secondary500,
            shape: BoxShape.circle,
          ),
          child: Text(
            initials.toUpperCase(),
            style: theme.textStyle.paragraphLabel.copyWith(
              color: theme.colors.onColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        SizedBox(width: theme.spacing.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'home.greeting'.tr(),
                style: theme.textStyle.captionDefault.copyWith(
                  color: theme.colors.onColor.withAlpha((255 * 0.75).round()),
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      agentName,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textStyle.paragraphLabel.copyWith(
                        color: theme.colors.onColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(width: theme.spacing.spacing8),
                  _RoleChip(theme: theme),
                ],
              ),
            ],
          ),
        ),
        _NotificationButton(theme: theme),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing8,
        vertical: 1,
      ),
      decoration: BoxDecoration(
        color: theme.colors.secondary500.withAlpha((255 * 0.18).round()),
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Text(
        'home.role'.tr(),
        style: theme.textStyle.captionDefault.copyWith(
          color: theme.colors.secondary300,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: theme.colors.onColor.withAlpha((255 * 0.12).round()),
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.notifications_none_rounded,
            color: theme.colors.onColor,
            size: 22,
          ),
          Positioned(
            top: 10,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: theme.colors.secondary500,
                shape: BoxShape.circle,
                border: Border.all(color: theme.colors.brand700, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommissionCard extends StatelessWidget {
  const _CommissionCard({
    required this.monthlyCommission,
    required this.pendingCommission,
    required this.dealsClosed,
    required this.theme,
  });

  final double monthlyCommission;
  final double pendingCommission;
  final int dealsClosed;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(theme.spacing.spacing20),
      decoration: BoxDecoration(
        color: theme.colors.white,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
        boxShadow: [
          BoxShadow(
            color: theme.colors.brand900.withAlpha((255 * 0.18).round()),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: theme.colors.secondary50,
                  borderRadius: BorderRadius.circular(
                    theme.borderRadius.borderRadius8,
                  ),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: theme.colors.secondary600,
                  size: 19,
                ),
              ),
              SizedBox(width: theme.spacing.spacing8),
              Text(
                'home.commission_month'.tr(),
                style: theme.textStyle.paragraphDefault
                    .copyWith(color: theme.colors.neutral600),
              ),
            ],
          ),
          SizedBox(height: theme.spacing.spacing12),
          Text(
            CurrencyFormat.fullVnd(monthlyCommission),
            style: theme.textStyle.heading.copyWith(
              color: theme.colors.secondary600,
              fontWeight: FontWeight.w800,
              fontSize: 28,
            ),
          ),
          SizedBox(height: theme.spacing.spacing16),
          Divider(height: 1, color: theme.colors.neutral100),
          SizedBox(height: theme.spacing.spacing12),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'home.commission_pending'.tr(),
                  value: CurrencyFormat.compactVnd(pendingCommission),
                  theme: theme,
                ),
              ),
              Container(width: 1, height: 32, color: theme.colors.neutral100),
              Expanded(
                child: _MiniStat(
                  label: 'home.deals_closed'.tr(),
                  value: '$dealsClosed',
                  theme: theme,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.theme,
  });

  final String label;
  final String value;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textStyle.captionDefault
                .copyWith(color: theme.colors.neutral500),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textStyle.paragraphLabel.copyWith(
              color: theme.colors.brand700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
