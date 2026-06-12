import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeInitialized>(_onInitialized);
    on<HomeRefreshed>(_onRefreshed);
  }

  Future<void> _onInitialized(
    HomeInitialized event,
    Emitter<HomeState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefreshed(
    HomeRefreshed event,
    Emitter<HomeState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<HomeState> emit) async {
    emit(const HomeLoading());
    // TODO: inject and call repository
    await Future<void>.delayed(const Duration(milliseconds: 500));
    emit(const HomeLoaded(
      userName: 'Nguyen Van A',
      totalBalance: 50000000,
      activeLoans: 2,
    ));
  }
}
