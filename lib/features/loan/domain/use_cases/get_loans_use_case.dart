import '../../../../core/use_case/use_case.dart';
import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

/// Returns the full list of loans for the current user.
class GetLoansUseCase implements UseCase<List<LoanEntity>, NoParams> {
  const GetLoansUseCase({required this.loanRepository});

  final LoanRepository loanRepository;

  @override
  Future<List<LoanEntity>> execute(NoParams _) => loanRepository.getLoans();
}
