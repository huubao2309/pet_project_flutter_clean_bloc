import '../../domain/entities/loan_entity.dart';

sealed class LoanState {
  const LoanState();
}

final class LoanInitial extends LoanState {
  const LoanInitial();
}

final class LoanLoading extends LoanState {
  const LoanLoading();
}

final class LoanListLoaded extends LoanState {
  const LoanListLoaded(this.loans);
  final List<LoanEntity> loans;
}

final class LoanDetailLoaded extends LoanState {
  const LoanDetailLoaded(this.loan);
  final LoanEntity loan;
}

final class LoanApplicationSuccess extends LoanState {
  const LoanApplicationSuccess(this.loan);
  final LoanEntity loan;
}

final class LoanFailure extends LoanState {
  const LoanFailure(this.message);
  final String message;
}
