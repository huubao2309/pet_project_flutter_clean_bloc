import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../../../core/use_case/use_case.dart';
import '../../domain/use_cases/apply_loan_use_case.dart';
import '../../domain/use_cases/get_loan_detail_use_case.dart';
import '../../domain/use_cases/get_loans_use_case.dart';
import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc({
    required this.getLoansUseCase,
    required this.getLoanDetailUseCase,
    required this.applyLoanUseCase,
  }) : super(const LoanInitial()) {
    on<LoanListRequested>(_onListRequested);
    on<LoanDetailRequested>(_onDetailRequested);
    on<LoanApplicationSubmitted>(_onApplicationSubmitted);
  }

  final GetLoansUseCase getLoansUseCase;
  final GetLoanDetailUseCase getLoanDetailUseCase;
  final ApplyLoanUseCase applyLoanUseCase;

  Future<void> _onListRequested(
    LoanListRequested event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    try {
      final loans = await getLoansUseCase.execute(const NoParams());
      emit(LoanListLoaded(loans));
    } on AppException catch (e) {
      emit(LoanFailure(e.message));
    }
  }

  Future<void> _onDetailRequested(
    LoanDetailRequested event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    try {
      final loan = await getLoanDetailUseCase.execute(
        GetLoanDetailParams(loanId: event.loanId),
      );
      emit(LoanDetailLoaded(loan));
    } on AppException catch (e) {
      emit(LoanFailure(e.message));
    }
  }

  Future<void> _onApplicationSubmitted(
    LoanApplicationSubmitted event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    try {
      final loan = await applyLoanUseCase.execute(
        ApplyLoanParams(amount: event.amount, termMonths: event.termMonths),
      );
      emit(LoanApplicationSuccess(loan));
    } on AppException catch (e) {
      emit(LoanFailure(e.message));
    }
  }
}
