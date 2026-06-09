enum LoanStatus { pending, approved, rejected, disbursed, repaying, closed }

class LoanEntity {
  const LoanEntity({
    required this.id,
    required this.amount,
    required this.termMonths,
    required this.interestRate,
    required this.status,
    required this.createdAt,
    this.disbursedAt,
    this.nextDueDate,
    this.remainingBalance,
  });

  final String id;

  /// Số tiền vay (VND).
  final double amount;

  /// Kỳ hạn tính bằng tháng.
  final int termMonths;

  /// Lãi suất năm (%).
  final double interestRate;

  final LoanStatus status;
  final DateTime createdAt;
  final DateTime? disbursedAt;
  final DateTime? nextDueDate;
  final double? remainingBalance;
}
