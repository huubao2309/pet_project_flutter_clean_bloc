import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/app_routes.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeInitialized()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('home.title'.tr()),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => switch (state) {
          HomeLoading() => const Center(child: CircularProgressIndicator()),
          HomeLoaded(:final userName, :final totalBalance, :final activeLoans) =>
            _LoadedBody(
              userName: userName,
              totalBalance: totalBalance,
              activeLoans: activeLoans,
            ),
          HomeFailure(:final message) => Center(child: Text(message)),
          _ => const SizedBox.shrink(),
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(AppRoutes.apply),
        icon: const Icon(Icons.add),
        label: Text('home.apply_loan'.tr()),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({
    required this.userName,
    required this.totalBalance,
    required this.activeLoans,
  });

  final String userName;
  final double totalBalance;
  final int activeLoans;

  @override
  Widget build(BuildContext context) {
    final numberFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<HomeBloc>().add(const HomeRefreshed()),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'home.greeting'.tr(namedArgs: {'name': userName}),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('home.total_balance'.tr(),
                      style: Theme.of(context).textTheme.labelLarge),
                  const SizedBox(height: 8),
                  Text(
                    numberFormat.format(totalBalance),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            title: Text('home.active_loans'.tr()),
            trailing: Text(
              '$activeLoans',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            onTap: () => context.push(AppRoutes.loans),
          ),
        ],
      ),
    );
  }
}
