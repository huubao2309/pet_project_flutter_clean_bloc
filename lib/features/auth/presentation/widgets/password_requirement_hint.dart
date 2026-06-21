import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../view_model/password_strength.dart';
import 'validate_icon_widget.dart';

/// Compact password-requirement affordance for the create-password form.
///
/// Replaces the always-visible checklist: a single "Yêu cầu mật khẩu" line with
/// an ⓘ icon that toggles a popover listing the live rule states. Once every
/// rule passes it collapses into a green "Mật khẩu hợp lệ" confirmation. Defined
/// for both Light and Dark mode via theme tokens.
class PasswordRequirementHint extends StatefulWidget {
  const PasswordRequirementHint({
    required this.strength,
    required this.isPasswordEmpty,
    super.key,
  });

  final PasswordStrength strength;

  /// Whether the password field is still empty — drives the "unknown" rule
  /// state (neutral, not a failure) before the user starts typing.
  final bool isPasswordEmpty;

  @override
  State<PasswordRequirementHint> createState() =>
      _PasswordRequirementHintState();
}

class _PasswordRequirementHintState extends State<PasswordRequirementHint> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final strength = widget.strength;
    final isEmpty = widget.isPasswordEmpty;
    final isValid = strength.isAllValid;

    if (isValid) {
      return Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: theme.colors.success500,
          ),
          SizedBox(width: theme.spacing.spacing8),
          Text(
            'auth.register.password_valid'.tr(),
            style: theme.textStyle.captionDefault.copyWith(
              color: theme.colors.success500,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          borderRadius:
              BorderRadius.circular(theme.borderRadius.borderRadius8),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: theme.spacing.spacing4),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 18,
                  color: theme.colors.brand600,
                ),
                SizedBox(width: theme.spacing.spacing8),
                Text(
                  'auth.register.password_requirements'.tr(),
                  style: theme.textStyle.captionDefault.copyWith(
                    color: theme.colors.brand600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: theme.spacing.spacing4),
                Icon(
                  _expanded ? Icons.expand_less : Icons.expand_more,
                  size: 18,
                  color: theme.colors.brand600,
                ),
              ],
            ),
          ),
        ),
        if (_expanded) ...[
          SizedBox(height: theme.spacing.spacing8),
          _RulePopover(strength: strength, isEmpty: isEmpty),
        ],
      ],
    );
  }
}

class _RulePopover extends StatelessWidget {
  const _RulePopover({required this.strength, required this.isEmpty});

  final PasswordStrength strength;
  final bool isEmpty;

  ValidIconState _ruleState(bool passed) {
    if (isEmpty) {
      return ValidIconState.unknown;
    }
    return passed ? ValidIconState.valid : ValidIconState.invalid;
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final ruleStyle = theme.textStyle.captionDefault
        .copyWith(color: theme.colors.neutral600);

    final rules = <({bool passed, String key})>[
      (passed: strength.hasMinLength, key: 'auth.register.password_length'),
      (passed: strength.hasSpecialChar, key: 'auth.register.password_special'),
      (passed: strength.hasNumber, key: 'auth.register.password_number'),
      (passed: strength.hasCapital, key: 'auth.register.password_capital'),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing12,
        vertical: theme.spacing.spacing12,
      ),
      decoration: BoxDecoration(
        color: theme.colors.surfaceElevated,
        border: Border.all(color: theme.colors.neutral100),
        borderRadius:
            BorderRadius.circular(theme.borderRadius.borderRadius8),
        boxShadow: [
          BoxShadow(
            color: theme.colors.brand900.withAlpha((255 * 0.08).round()),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: theme.spacing.spacing8),
            child: Text(
              'auth.register.password_must'.tr(),
              style: theme.textStyle.captionDefault.copyWith(
                color: theme.colors.brand800,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (var i = 0; i < rules.length; i++)
            Padding(
              padding: EdgeInsets.only(
                bottom:
                    i == rules.length - 1 ? 0 : theme.spacing.spacing8,
              ),
              child: ValidateIconWidget(
                state: _ruleState(rules[i].passed),
                sizeIcon: 18,
                spacing: theme.spacing.spacing8,
                title: rules[i].key.tr(),
                textStyle: ruleStyle,
              ),
            ),
        ],
      ),
    );
  }
}
