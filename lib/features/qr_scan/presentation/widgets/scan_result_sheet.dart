import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/currency_format.dart';
import '../../domain/entities/scanned_property.dart';

/// Outcome of the result sheet: open the detail screen, or resume scanning.
enum ScanResultAction { viewDetail, scanAgain }

/// Bottom sheet shown after a successful scan, summarising the resolved
/// property. Returns the [ScanResultAction] the user chose (null if dismissed).
Future<ScanResultAction?> showScanResultSheet(
  BuildContext context,
  ScannedProperty property,
) {
  final theme = getIt<ThemeState>();
  return showModalBottomSheet<ScanResultAction>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: theme.colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _ScanResultSheet(property: property),
  );
}

class _ScanResultSheet extends StatelessWidget {
  const _ScanResultSheet({required this.property});

  final ScannedProperty property;

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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [theme.colors.brand400, theme.colors.brand600],
                    ),
                    borderRadius: BorderRadius.circular(
                      theme.borderRadius.borderRadius16,
                    ),
                  ),
                  child: Icon(
                    Icons.apartment_rounded,
                    color: theme.colors.onColor.withAlpha((255 * 0.4).round()),
                    size: 30,
                  ),
                ),
                SizedBox(width: theme.spacing.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ScannedBadge(theme: theme),
                      SizedBox(height: theme.spacing.spacing4),
                      Text(
                        property.title,
                        style: theme.textStyle.paragraphLabel.copyWith(
                          color: theme.colors.brand800,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'qr.result_specs'.tr(
                          namedArgs: {
                            'address': property.address,
                            'area': property.area.toStringAsFixed(0),
                            'bedrooms': '${property.bedrooms}',
                          },
                        ),
                        style: theme.textStyle.captionDefault
                            .copyWith(color: theme.colors.neutral500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.spacing.spacing12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  CurrencyFormat.compactVnd(property.price),
                  style: theme.textStyle.heading.copyWith(
                    color: theme.colors.secondary600,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: theme.spacing.spacing12,
                    vertical: theme.spacing.spacing4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colors.secondary50,
                    borderRadius: BorderRadius.circular(
                      theme.borderRadius.borderRadius16,
                    ),
                  ),
                  child: Text(
                    'qr.result_commission'.tr(
                      namedArgs: {
                        'amount': CurrencyFormat.compactVnd(
                          property.commissionAmount,
                        ),
                      },
                    ),
                    style: theme.textStyle.captionDefault.copyWith(
                      color: theme.colors.secondary700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: theme.spacing.spacing16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () =>
                    Navigator.of(context).pop(ScanResultAction.viewDetail),
                style: FilledButton.styleFrom(
                  backgroundColor: theme.colors.brand600,
                  padding:
                      EdgeInsets.symmetric(vertical: theme.spacing.spacing12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(theme.borderRadius.borderRadius8),
                  ),
                ),
                child: Text('qr.view_detail'.tr()),
              ),
            ),
            SizedBox(height: theme.spacing.spacing8),
            Center(
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context).pop(ScanResultAction.scanAgain),
                child: Text(
                  'qr.scan_again'.tr(),
                  style: theme.textStyle.paragraphDefault
                      .copyWith(color: theme.colors.neutral500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScannedBadge extends StatelessWidget {
  const _ScannedBadge({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacing.spacing8,
        vertical: theme.spacing.spacing2,
      ),
      decoration: BoxDecoration(
        color: theme.colors.success50,
        borderRadius: BorderRadius.circular(theme.borderRadius.borderRadius16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_rounded,
            size: 12,
            color: theme.colors.success700,
          ),
          const SizedBox(width: 3),
          Text(
            'qr.scanned'.tr(),
            style: theme.textStyle.captionDefault.copyWith(
              color: theme.colors.success700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
