import '../../../../core/presentation/view_model.dart';
import '../../domain/entities/deal_record.dart';
import '../../domain/entities/property_listing.dart';
import 'home_state.dart';

/// View model (MVVM) for the home dashboard. The View calls [initialize] /
/// [refresh] instead of dispatching events. Data is mocked for now; swap the
/// body of [_load] for real use cases later.
class HomeViewModel extends ViewModel<HomeState> {
  HomeViewModel() : super(const HomeInitial());

  Future<void> initialize() => _load();

  Future<void> refresh() => _load();

  Future<void> _load() async {
    setState(const HomeLoading());
    await Future<void>.delayed(const Duration(milliseconds: 500));
    setState(
      const HomeLoaded(
        agentName: 'Bảo Nguyễn',
        monthlyCommission: 86500000,
        pendingCommission: 42000000,
        dealsClosed: 4,
        activeListings: 12,
        potentialCustomers: 28,
        listings: _mockListings,
        recentDeals: _mockDeals,
      ),
    );
  }

  static const List<PropertyListing> _mockListings = [
    PropertyListing(
      id: 'p1',
      title: 'Vinhomes Central Park',
      address: 'Bình Thạnh, TP. HCM',
      price: 5600000000,
      area: 78,
      bedrooms: 2,
      type: 'Căn hộ',
      status: PropertyStatus.available,
    ),
    PropertyListing(
      id: 'p2',
      title: 'Nhà phố Thảo Điền',
      address: 'TP. Thủ Đức, TP. HCM',
      price: 14500000000,
      area: 120,
      bedrooms: 4,
      type: 'Nhà phố',
      status: PropertyStatus.deposited,
    ),
    PropertyListing(
      id: 'p3',
      title: 'The Origami S9',
      address: 'Vinhomes Grand Park, Q.9',
      price: 3200000000,
      area: 65,
      bedrooms: 2,
      type: 'Căn hộ',
      status: PropertyStatus.available,
    ),
  ];

  static const List<DealRecord> _mockDeals = [
    DealRecord(
      id: 'd1',
      propertyTitle: 'Masteri Thảo Điền',
      customerName: 'Anh Tuấn',
      dealValue: 4800000000,
      commission: 48000000,
      dateLabel: '12/06/2026',
      status: DealStatus.completed,
    ),
    DealRecord(
      id: 'd2',
      propertyTitle: 'Sunrise City View',
      customerName: 'Chị Lan',
      dealValue: 3500000000,
      commission: 21000000,
      dateLabel: '05/06/2026',
      status: DealStatus.deposited,
    ),
    DealRecord(
      id: 'd3',
      propertyTitle: 'Lavita Charm',
      customerName: 'Anh Minh',
      dealValue: 2700000000,
      commission: 17500000,
      dateLabel: '28/05/2026',
      status: DealStatus.completed,
    ),
  ];
}
