sealed class HomeEvent {
  const HomeEvent();
}

final class HomeInitialized extends HomeEvent {
  const HomeInitialized();
}

final class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}
