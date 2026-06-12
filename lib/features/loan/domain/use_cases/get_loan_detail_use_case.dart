import '../../../../core/use_case/use_case.dart';
import '../entities/loan_entity.dart';
import '../repositories/loan_repository.dart';

class GetLoanDetailParams {
  const GetLoanDetailParams({required this.loanId});

  final String loanId;
}

/// Returns the detail of a single loan by its ID.
class GetLoanDetailUseCase implements UseCase<LoanEntity, GetLoanDetailParams> {
  const GetLoanDetailUseCase({required this.loanRepository});

  final LoanRepository loanRepository;

  @override
  Future<LoanEntity> execute(GetLoanDetailParams params) =>
      loanRepository.getLoanById(params.loanId);
}
