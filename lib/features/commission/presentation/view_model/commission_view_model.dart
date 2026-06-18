import '../../../../core/presentation/view_model.dart';
import '../../domain/entities/commission_filter.dart';
import '../../domain/entities/commission_listing.dart';
import 'commission_state.dart';

/// View model (MVVM) for the Commission (Hoa hồng) feed. The View calls
/// [initialize] / [refreshLocation] / [applyFilter] instead of dispatching
/// events. Data is mocked for now — swap [_fetchNearby] for a real use case
/// (location service + listings API) later without touching the View.
class CommissionViewModel extends ViewModel<CommissionState> {
  CommissionViewModel() : super(const CommissionInitial());

  CommissionFilter _filter = const CommissionFilter();
  List<CommissionListing> _source = const [];
  String _locationLabel = '';
  double _radiusKm = 0;

  Future<void> initialize() => _locateAndLoad();

  /// Re-resolves the current location (the AppBar "get my location" action) and
  /// reloads the nearby high-commission listings.
  Future<void> refreshLocation() => _locateAndLoad();

  /// Applies a new sort/status [filter] and re-publishes the visible list. No
  /// network round-trip — sorting and filtering happen in memory.
  void applyFilter(CommissionFilter filter) {
    _filter = filter;
    final current = currentState;
    if (current is CommissionLoaded) {
      setState(
        current.copyWith(filter: filter, listings: _visible()),
      );
    }
  }

  Future<void> _locateAndLoad() async {
    setState(const CommissionLocating());
    // Simulate resolving GPS + querying the backend within the radius.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    _locationLabel = 'Quận 1';
    _radiusKm = 5;
    _source = _mockListings;
    setState(
      CommissionLoaded(
        locationLabel: _locationLabel,
        radiusKm: _radiusKm,
        totalCount: _source.length,
        filter: _filter,
        listings: _visible(),
      ),
    );
  }

  /// Builds the filtered + sorted list from the in-memory source.
  List<CommissionListing> _visible() {
    final filtered = _filter.hasStatusFilter
        ? _source.where((l) => _filter.statuses.contains(l.status)).toList()
        : List<CommissionListing>.from(_source);

    int byScore(CommissionListing a, CommissionListing b) =>
        b.commissionScore.compareTo(a.commissionScore);

    switch (_filter.sort) {
      case CommissionSort.score:
        filtered.sort(byScore);
      case CommissionSort.priceDesc:
        filtered.sort((a, b) => b.price.compareTo(a.price));
      case CommissionSort.priceAsc:
        filtered.sort((a, b) => a.price.compareTo(b.price));
      case CommissionSort.nearest:
        filtered.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    }
    return filtered;
  }

  static const List<CommissionListing> _mockListings = [
    CommissionListing(
      id: 'c1',
      title: 'The Marq Quận 1',
      address: 'Quận 1, TP. HCM',
      distanceKm: 1.2,
      price: 8500000000,
      commissionRate: 0.03,
      commissionAmount: 255000000,
      commissionScore: 9.4,
      type: 'Căn hộ',
      status: CommissionStatus.urgentSell,
      expiresInDays: 2,
    ),
    CommissionListing(
      id: 'c2',
      title: 'Saigon Pearl',
      address: 'Bình Thạnh, TP. HCM',
      distanceKm: 3.4,
      price: 6200000000,
      commissionRate: 0.025,
      commissionAmount: 155000000,
      commissionScore: 8.1,
      type: 'Căn hộ',
      status: CommissionStatus.available,
    ),
    CommissionListing(
      id: 'c3',
      title: 'Nhà phố Thảo Điền',
      address: 'TP. Thủ Đức, TP. HCM',
      distanceKm: 5.0,
      price: 14500000000,
      commissionRate: 0.02,
      commissionAmount: 290000000,
      commissionScore: 8.8,
      type: 'Nhà phố',
      status: CommissionStatus.deposited,
    ),
    CommissionListing(
      id: 'c4',
      title: 'Vinhomes Golden River',
      address: 'Quận 1, TP. HCM',
      distanceKm: 2.1,
      price: 9800000000,
      commissionRate: 0.028,
      commissionAmount: 274000000,
      commissionScore: 9.0,
      type: 'Căn hộ',
      status: CommissionStatus.urgentSell,
      expiresInDays: 5,
    ),
    CommissionListing(
      id: 'c5',
      title: 'The Origami S9',
      address: 'Vinhomes Grand Park, TP. Thủ Đức',
      distanceKm: 8.7,
      price: 3200000000,
      commissionRate: 0.022,
      commissionAmount: 70400000,
      commissionScore: 7.3,
      type: 'Căn hộ',
      status: CommissionStatus.available,
      expiresInDays: 3,
    ),
  ];
}
