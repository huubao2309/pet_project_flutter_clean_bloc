/// Immutable UI state for the home feature. Library-agnostic (no Bloc/GetX
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
    required this.userName,
    required this.totalBalance,
    required this.activeLoans,
  });

  final String userName;

  /// Tổng dư nợ (VND).
  final double totalBalance;
  final int activeLoans;
}

final class HomeFailure extends HomeState {
  const HomeFailure(this.message);
  final String message;
}
