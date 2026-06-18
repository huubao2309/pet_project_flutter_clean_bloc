import 'package:equatable/equatable.dart';

import 'commission_listing.dart';

/// How the commission feed is ordered.
enum CommissionSort { score, priceDesc, priceAsc, nearest }

/// Immutable selection of sort order plus an optional set of statuses to keep.
/// An empty [statuses] set means "show all statuses".
class CommissionFilter extends Equatable {
  const CommissionFilter({
    this.sort = CommissionSort.score,
    this.statuses = const {},
  });

  final CommissionSort sort;
  final Set<CommissionStatus> statuses;

  bool get hasStatusFilter => statuses.isNotEmpty;

  CommissionFilter copyWith({
    CommissionSort? sort,
    Set<CommissionStatus>? statuses,
  }) {
    return CommissionFilter(
      sort: sort ?? this.sort,
      statuses: statuses ?? this.statuses,
    );
  }

  /// Returns a copy with [status] toggled in/out of the status filter set.
  CommissionFilter toggleStatus(CommissionStatus status) {
    final next = Set<CommissionStatus>.from(statuses);
    if (!next.add(status)) {
      next.remove(status);
    }
    return copyWith(statuses: next);
  }

  @override
  List<Object?> get props => [sort, statuses];
}
