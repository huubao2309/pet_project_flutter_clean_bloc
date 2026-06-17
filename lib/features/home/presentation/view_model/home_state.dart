import '../../domain/entities/deal_record.dart';
import '../../domain/entities/property_listing.dart';

/// Immutable UI state for the home dashboard. Library-agnostic (no Bloc/GetX
/// types) so it survives a state-management migration unchanged.
sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {
  const HomeInitial();
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.agentName,
    required this.monthlyCommission,
    required this.pendingCommission,
    required this.dealsClosed,
    required this.activeListings,
    required this.potentialCustomers,
    required this.listings,
    required this.recentDeals,
  });

  final String agentName;

  /// Commission earned so far this month (VND).
  final double monthlyCommission;

  /// Commission booked but not yet paid out (VND).
  final double pendingCommission;

  /// Deals closed this month.
  final int dealsClosed;

  /// Listings the collaborator currently has on the market.
  final int activeListings;

  /// Leads still in the pipeline.
  final int potentialCustomers;

  final List<PropertyListing> listings;
  final List<DealRecord> recentDeals;
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.message);
  final String message;
}
