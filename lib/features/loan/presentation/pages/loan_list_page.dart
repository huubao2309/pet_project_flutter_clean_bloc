import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../../domain/entities/loan_entity.dart';
import '../../domain/repositories/loan_repository.dart';
import '../bloc/loan_bloc.dart';
import '../bloc/loan_event.dart';
import '../bloc/loan_state.dart';

class LoanListPage extends StatelessWidget {
  const LoanListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace _StubLoanRepository with real impl from GetIt
    return BlocProvider(
      create: (_) => LoanBloc(
        loanRepository: _StubLoanRepository(),
      )..add(const LoanListRequested()),
      child: const _LoanListView(),
    );
  }
}

class _LoanListView extends StatelessWidget {
  const _LoanListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('loan.title'.tr())),
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) => switch (state) {
          LoanLoading() => const Center(child: CircularProgressIndicator()),
          LoanListLoaded(:final loans) when loans.isEmpty =>
            Center(child: Text('common.empty'.tr())),
          LoanListLoaded(:final loans) => ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: loans.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (ctx, i) => _LoanCard(loan: loans[i]),
            ),
          LoanFailure(:final message) => Center(child: Text(message)),
          _ => const SizedBox.shrink(),
        },
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({required this.loan});

  final LoanEntity loan;

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return ListTile(
      title: Text(fmt.format(loan.amount)),
      subtitle: Text(
        'loan.term'.tr(namedArgs: {'months': '${loan.termMonths}'}),
      ),
      trailing: _StatusChip(status: loan.status),
      onTap: () => context.push(AppRoutes.loanDetailPath(loan.id)),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final LoanStatus status;

  Color _color() => switch (status) {
        LoanStatus.approved || LoanStatus.disbursed => Colors.green,
        LoanStatus.rejected => Colors.red,
        LoanStatus.repaying => Colors.blue,
        LoanStatus.closed => Colors.grey,
        LoanStatus.pending => Colors.orange,
      };

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(
        'loan.status.${status.name}'.tr(),
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
      backgroundColor: _color(),
      padding: EdgeInsets.zero,
    );
  }
}

/// Placeholder repository — replace with the real DI-registered implementation.
class _StubLoanRepository implements LoanRepository {
  @override
  Future<List<LoanEntity>> getLoans() async => [];

  @override
  Future<LoanEntity> getLoanById(String loanId) =>
      throw UnimplementedError();

  @override
  Future<LoanEntity> applyForLoan({
    required double amount,
    required int termMonths,
  }) => throw UnimplementedError();
}
