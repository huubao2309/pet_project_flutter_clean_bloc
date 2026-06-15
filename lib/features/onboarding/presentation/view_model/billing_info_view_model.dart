import '../../../../core/presentation/view_model.dart';
import 'billing_info_state.dart';

/// View model for the billing-info onboarding step. Pure form state for now;
/// when a backend exists, [submit] should delegate to a use case.
class BillingInfoViewModel extends ViewModel<BillingInfoState> {
  BillingInfoViewModel() : super(const BillingInfoState());

  void onNameOnCardChanged(String value) =>
      setState(currentState.copyWith(nameOnCard: value));

  void onCardNumberChanged(String value) =>
      setState(currentState.copyWith(cardNumber: value));

  void onCvcChanged(String value) =>
      setState(currentState.copyWith(cvc: value));

  void onMonthChanged(String value) =>
      setState(currentState.copyWith(month: value));

  void onYearChanged(String value) =>
      setState(currentState.copyWith(year: value));

  /// Returns whether the step is valid and can finish. No backend call yet.
  bool submit() => currentState.canSubmit;
}
