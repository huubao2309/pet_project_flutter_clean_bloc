/// Immutable form state for the billing-info onboarding step.
class BillingInfoState {
  const BillingInfoState({
    this.nameOnCard = '',
    this.cardNumber = '',
    this.cvc = '',
    this.month = '',
    this.year = '',
  });

  final String nameOnCard;
  final String cardNumber;
  final String cvc;
  final String month;
  final String year;

  bool get canSubmit =>
      nameOnCard.isNotEmpty &&
      cardNumber.isNotEmpty &&
      cvc.isNotEmpty &&
      month.isNotEmpty &&
      year.isNotEmpty;

  BillingInfoState copyWith({
    String? nameOnCard,
    String? cardNumber,
    String? cvc,
    String? month,
    String? year,
  }) {
    return BillingInfoState(
      nameOnCard: nameOnCard ?? this.nameOnCard,
      cardNumber: cardNumber ?? this.cardNumber,
      cvc: cvc ?? this.cvc,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }
}
