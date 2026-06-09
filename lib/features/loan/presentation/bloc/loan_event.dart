sealed class LoanEvent {
  const LoanEvent();
}

final class LoanListRequested extends LoanEvent {
  const LoanListRequested();
}

final class LoanDetailRequested extends LoanEvent {
  const LoanDetailRequested(this.loanId);
  final String loanId;
}

final class LoanApplicationSubmitted extends LoanEvent {
  const LoanApplicationSubmitted({
    required this.amount,
    required this.termMonths,
  });
  final double amount;
  final int termMonths;
}
