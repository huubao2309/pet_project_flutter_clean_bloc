import '../../../../core/presentation/view_model.dart';
import 'home_state.dart';

/// View model (MVVM) for the home dashboard. The View calls [initialize] /
/// [refresh] instead of dispatching events.
class HomeViewModel extends ViewModel<HomeState> {
  HomeViewModel() : super(const HomeInitial());

  Future<void> initialize() => _load();

  Future<void> refresh() => _load();

  Future<void> _load() async {
    setState(const HomeLoading());
    // TODO: inject and call home use cases (stubbed for now).
    await Future<void>.delayed(const Duration(milliseconds: 500));
    setState(
      const HomeLoaded(
        userName: 'Nguyen Van A',
        totalBalance: 50000000,
        activeLoans: 2,
      ),
    );
  }
}
