import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/home_state.dart';
import '../view_model/home_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<HomeViewModel>(
      create: (_) => getIt<HomeViewModel>()..initialize(),
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
      body: ViewModelBuilder<HomeViewModel, HomeState>(
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
      onRefresh: () => context.viewModel<HomeViewModel>().refresh(),
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
                  Text(
                    'home.total_balance'.tr(),
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
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
          ),
          ListTile(
            leading: const Icon(Icons.assignment_ind_outlined),
            title: Text('onboarding.personal_info'.tr()),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.personalInfo),
          ),
        ],
      ),
    );
  }
}
