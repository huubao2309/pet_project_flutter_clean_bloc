part of '../app_exception.dart';

/// The phone number is blocked by the backend (verdict `phone_is_blocked`) — a
/// hard stop, surfaced full-screen rather than as a snackbar.
///
/// Named after the cause (a blocked phone), not the flow, so any operation that
/// hits this verdict — sign-up today, others later — can throw it; each flow's
/// view model then decides what to show. A single cause today means no reason
/// enum; generalise (like [AccountBlockedException]/[BlockReason]) if more
/// phone-block cases appear.
final class PhoneBlockedException extends AppException {
  PhoneBlockedException([String? message])
      : super(message ?? 'errors.unknown'.tr());
}
