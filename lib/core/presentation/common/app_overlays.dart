/// Reusable dialog & bottom-sheet overlays for the whole app.
///
/// Import this single barrel instead of calling `showDialog` /
/// `showModalBottomSheet` directly. The UI follows design system §13 (Dialog)
/// and §14 (Bottom Sheet); every field is optional so call sites stay terse
/// while a restyle stays centralised.
///
/// ```dart
/// // Centred confirmation dialog.
/// final ok = await AppDialog.confirm(
///   title: 'auth.logout_title'.tr(),
///   message: 'auth.logout_message'.tr(),
/// );
///
/// // Destructive dialog (red action).
/// final remove = await AppDialog.destructive(
///   title: 'Xoá tài khoản?',
///   message: 'Hành động này không thể hoàn tác.',
///   confirmLabel: 'Xoá',
/// );
///
/// // Quick action menu (no footer).
/// final index = await AppBottomSheet.options(
///   title: 'Tuỳ chọn',
///   options: [
///     AppSheetOption(label: 'Chỉnh sửa', leadingIcon: Icons.edit_rounded),
///     AppSheetOption(label: 'Xoá', leadingIcon: Icons.delete_rounded,
///         isDestructive: true),
///   ],
/// );
///
/// // Fully custom — every field optional.
/// await AppBottomSheet.show(
///   title: 'Chọn ngân hàng',
///   body: const BankList(),
///   actions: [AppOverlayAction(label: 'Xác nhận')],
/// );
/// ```
library;

export 'app_bottom_sheet.dart';
export 'app_dialog.dart';
export 'app_overlay_action.dart';
export 'app_sheet_option.dart';
export 'widgets/app_overlay_icon.dart';
