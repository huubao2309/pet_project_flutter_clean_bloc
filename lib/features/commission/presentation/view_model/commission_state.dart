import '../../domain/entities/commission_filter.dart';
import '../../domain/entities/commission_listing.dart';

/// Immutable UI state for the Commission (Hoa hồng) feed. Library-agnostic so
/// it survives a state-management migration unchanged.
sealed class CommissionState {
  const CommissionState();
}

final class CommissionInitial extends CommissionState {
  const CommissionInitial();
}

/// Resolving the collaborator's current location before fetching nearby tips.
final class CommissionLocating extends CommissionState {
  const CommissionLocating();
}

final class CommissionLoaded extends CommissionState {
  const CommissionLoaded({
    required this.locationLabel,
    required this.radiusKm,
    required this.totalCount,
    required this.filter,
    required this.listings,
  });

  /// Human-readable area label of the resolved location, e.g. "Quận 1".
  final String locationLabel;

  /// Search radius in km the feed was gathered within.
  final double radiusKm;

  /// Number of listings found before status filtering (for the banner count).
  final int totalCount;

  final CommissionFilter filter;

  /// The sorted + filtered listings to render.
  final List<CommissionListing> listings;

  CommissionLoaded copyWith({
    String? locationLabel,
    double? radiusKm,
    int? totalCount,
    CommissionFilter? filter,
    List<CommissionListing>? listings,
  }) {
    return CommissionLoaded(
      locationLabel: locationLabel ?? this.locationLabel,
      radiusKm: radiusKm ?? this.radiusKm,
      totalCount: totalCount ?? this.totalCount,
      filter: filter ?? this.filter,
      listings: listings ?? this.listings,
    );
  }
}

final class CommissionFailure extends CommissionState {
  const CommissionFailure(this.message);
  final String message;
}
