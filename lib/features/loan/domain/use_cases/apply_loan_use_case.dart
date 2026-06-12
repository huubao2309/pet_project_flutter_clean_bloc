import '../../../../core/use_case/use_case.dart';
import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class ApplyLoanParams {
  const ApplyLoanParams({required this.amount, required this.termMonths});

  final double amount;
  final int termMonths;
}

/// Submits a new loan application and returns the created loan.
class ApplyLoanUseCase implements UseCase<LoanEntity, ApplyLoanParams> {
  const ApplyLoanUseCase({required this.loanRepository});

  final LoanRepository loanRepository;

  @override
  Future<LoanEntity> execute(ApplyLoanParams params) =>
      loanRepository.applyForLoan(
        amount: params.amount,
        termMonths: params.termMonths,
      );
}
