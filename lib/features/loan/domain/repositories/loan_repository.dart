import '../entities/loan_entity.dart';

abstract class LoanRepository {
  Future<List<LoanEntity>> getLoans();

  Future<LoanEntity> getLoanById(String loanId);

  Future<LoanEntity> applyForLoan({
    required double amount,
    required int termMonths,
  });
}
