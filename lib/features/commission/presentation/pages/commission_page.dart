import 'package:benny_style/theme/theme_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/presentation/presentation.dart';
import '../../domain/entities/commission_filter.dart';
import '../view_model/commission_state.dart';
import '../view_model/commission_view_model.dart';
import '../widgets/commission_card.dart';
import '../widgets/commission_filter_sheet.dart';
import '../widgets/commission_location_banner.dart';
import '../widgets/commission_sort_bar.dart';

/// Commission (Hoa hồng) tab — lists nearby high-commission properties ordered
/// by commission score, with a "use my location" AppBar action and a
/// sort/filter bar.
class CommissionPage extends StatelessWidget {
  const CommissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelProvider<CommissionViewModel>(
      create: (_) => getIt<CommissionViewModel>()..initialize(),
      child: const _CommissionView(),
    );
  }
}

class _CommissionView extends StatelessWidget {
  const _CommissionView();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Scaffold(
      backgroundColor: theme.colors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: theme.colors.surfaceBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Text(
          'nav.commission'.tr(),
          style: theme.textStyle.heading.copyWith(color: theme.colors.brand800),
        ),
        actions: const [_LocationAction()],
      ),
      body: ViewModelBuilder<CommissionViewModel, CommissionState>(
        builder: (context, state) => switch (state) {
          CommissionLoaded() => _LoadedBody(state: state),
          CommissionFailure(:final message) => Center(child: Text(message)),
          _ => _LocatingBody(theme: theme),
        },
      ),
    );
  }
}

class _LocationAction extends StatelessWidget {
  const _LocationAction();

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return ViewModelBuilder<CommissionViewModel, CommissionState>(
      builder: (context, state) {
        final locating = state is CommissionLocating;
        final label = state is CommissionLoaded
            ? state.locationLabel
            : 'commission.locating_short'.tr();

        return Padding(
          padding: EdgeInsets.only(right: theme.spacing.spacing12),
          child: GestureDetector(
            onTap: locating
                ? null
                : () =>
                    context.viewModel<CommissionViewModel>().refreshLocation(),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.spacing12,
                vertical: theme.spacing.spacing8,
              ),
              decoration: BoxDecoration(
                color:
                    locating ? theme.colors.secondary50 : theme.colors.brand50,
                borderRadius:
                    BorderRadius.circular(theme.borderRadius.borderRadius16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (locating)
                    SizedBox(
                      width: 12,
                      height: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: theme.colors.secondary600,
                      ),
                    )
                  else
                    Icon(
                      Icons.my_location_rounded,
                      size: 14,
                      color: theme.colors.secondary600,
                    ),
                  SizedBox(width: theme.spacing.spacing4),
                  Text(
                    label,
                    style: theme.textStyle.captionDefault.copyWith(
                      color: locating
                          ? theme.colors.secondary700
                          : theme.colors.brand700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LocatingBody extends StatelessWidget {
  const _LocatingBody({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: theme.colors.brand50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.travel_explore_rounded,
                size: 42,
                color: theme.colors.brand600,
              ),
            ),
            SizedBox(height: theme.spacing.spacing20),
            Text(
              'commission.locating_title'.tr(),
              textAlign: TextAlign.center,
              style: theme.textStyle.heading
                  .copyWith(color: theme.colors.brand800),
            ),
            SizedBox(height: theme.spacing.spacing8),
            Text(
              'commission.locating_subtitle'.tr(),
              textAlign: TextAlign.center,
              style: theme.textStyle.paragraphDefault
                  .copyWith(color: theme.colors.neutral500),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadedBody extends StatelessWidget {
  const _LoadedBody({required this.state});

  final CommissionLoaded state;

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();
    final viewModel = context.viewModel<CommissionViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            theme.spacing.spacing16,
            0,
            theme.spacing.spacing16,
            theme.spacing.spacing12,
          ),
          child: CommissionLocationBanner(
            locationLabel: state.locationLabel,
            radiusKm: state.radiusKm,
            count: state.totalCount,
            onRefresh: viewModel.refreshLocation,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing16),
          child: CommissionSortBar(
            filter: state.filter,
            onSortSelected: (sort) =>
                viewModel.applyFilter(state.filter.copyWith(sort: sort)),
            onOpenFilter: () => _openFilter(context, state.filter, viewModel),
          ),
        ),
        SizedBox(height: theme.spacing.spacing12),
        Expanded(
          child: state.listings.isEmpty
              ? _EmptyState(theme: theme)
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    theme.spacing.spacing16,
                    0,
                    theme.spacing.spacing16,
                    theme.spacing.spacing24,
                  ),
                  itemCount: state.listings.length,
                  separatorBuilder: (_, __) =>
                      SizedBox(height: theme.spacing.spacing12),
                  itemBuilder: (context, index) =>
                      CommissionCard(listing: state.listings[index]),
                ),
        ),
      ],
    );
  }

  Future<void> _openFilter(
    BuildContext context,
    CommissionFilter current,
    CommissionViewModel viewModel,
  ) async {
    final result = await showCommissionFilterSheet(context, current);
    if (result != null) {
      viewModel.applyFilter(result);
    }
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme});

  final ThemeState theme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 44,
              color: theme.colors.neutral300,
            ),
            SizedBox(height: theme.spacing.spacing12),
            Text(
              'commission.empty'.tr(),
              textAlign: TextAlign.center,
              style: theme.textStyle.paragraphDefault
                  .copyWith(color: theme.colors.neutral500),
            ),
          ],
        ),
      ),
    );
  }
}
