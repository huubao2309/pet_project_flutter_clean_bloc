import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../../../core/router/app_routes.dart';
import '../view_model/home_state.dart';
import '../view_model/home_view_model.dart';
import '../widgets/deal_tile.dart';
import '../widgets/home_header.dart';
import '../widgets/property_card.dart';
import '../widgets/quick_actions.dart';
import '../widgets/section_header.dart';
import '../widgets/stats_row.dart';

/// Home dashboard for the real-estate sales collaborator (CTV): commission
/// overview, quick actions, pipeline stats, featured listings and the recent
/// buy/sell history.
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
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      body: ViewModelBuilder<HomeViewModel, HomeState>(
        builder: (context, state) => switch (state) {
          HomeLoaded() => _LoadedBody(state: state),
          HomeFailure(:final message) => Center(child: Text(message)),
          _ => Center(
              child: CircularProgressIndicator(color: theme.colors.brand600),
            ),
        },
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final gap = SizedBox(height: theme.spacing.spacing24);

    return RefreshIndicator(
      color: theme.colors.brand600,
      onRefresh: () => context.viewModel<HomeViewModel>().refresh(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          HomeHeader(
            agentName: state.agentName,
            monthlyCommission: state.monthlyCommission,
            pendingCommission: state.pendingCommission,
            dealsClosed: state.dealsClosed,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              theme.spacing.spacing16,
              theme.spacing.spacing20,
              theme.spacing.spacing16,
              theme.spacing.spacing32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickActions(onScanQr: () => context.push(AppRoutes.qrScan)),
                gap,
                StatsRow(
                  activeListings: state.activeListings,
                  potentialCustomers: state.potentialCustomers,
                ),
                gap,
                SectionHeader(
                  titleKey: 'home.featured_listings',
                  onSeeAll: () {},
                ),
                SizedBox(height: theme.spacing.spacing12),
                _ListingsRail(state: state, theme: theme),
                gap,
                SectionHeader(titleKey: 'home.recent_history', onSeeAll: () {}),
                SizedBox(height: theme.spacing.spacing12),
                for (final deal in state.recentDeals)
                  Padding(
                    padding: EdgeInsets.only(bottom: theme.spacing.spacing12),
                    child: DealTile(deal: deal),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingsRail extends StatelessWidget {
  const _ListingsRail({required this.state, required this.theme});

  final HomeLoaded state;
  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        itemCount: state.listings.length,
        separatorBuilder: (_, __) => SizedBox(width: theme.spacing.spacing12),
        itemBuilder: (context, index) =>
            PropertyCard(listing: state.listings[index]),
      ),
    );
  }
}
