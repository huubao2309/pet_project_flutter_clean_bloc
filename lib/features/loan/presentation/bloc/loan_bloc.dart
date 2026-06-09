import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/app_exception.dart';
import '../../domain/repositories/loan_repository.dart';
import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc({required this.loanRepository}) : super(const LoanInitial()) {
    on<LoanListRequested>(_onListRequested);
    on<LoanDetailRequested>(_onDetailRequested);
    on<LoanApplicationSubmitted>(_onApplicationSubmitted);
  }

  final LoanRepository loanRepository;

  Future<void> _onListRequested(
    LoanListRequested event,
    Emitter<LoanState> emit,
  ) async {
    emit(const LoanLoading());
    try {
      final loans = await loanRepository.getLoans();
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
      final loan = await loanRepository.getLoanById(event.loanId);
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
      final loan = await loanRepository.applyForLoan(
        amount: event.amount,
        termMonths: event.termMonths,
      );
      emit(LoanApplicationSuccess(loan));
    } on AppException catch (e) {
      emit(LoanFailure(e.message));
    }
  }
}
