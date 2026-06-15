import 'package:flutter_bloc/flutter_bloc.dart';

/// Base class for every screen-level state holder in the app (the "VM" in
/// MVVM). Conceptually equivalent to a GetX `GetxController`, a MobX `Store`,
/// or a Riverpod `Notifier`.
///
/// ── Why this exists ─────────────────────────────────────────────────────
/// This is the ONLY place the presentation layer couples to a concrete
/// state-management library. Today it is backed by [Cubit] from
/// `flutter_bloc`. To migrate the whole app to GetX / MobX / Riverpod you
/// reimplement just this class plus the matching widgets in this folder
/// (`view_model_provider.dart`, `view_model_builder.dart`, …). Every feature's
/// view model and page keeps compiling unchanged, because they depend only on
/// these abstractions — never on `Cubit`, `BlocBuilder`, `Obx`, etc.
///
/// ── Contract for subclasses ─────────────────────────────────────────────
/// - Hold use cases (injected via constructor) and orchestrate them.
/// - Expose plain methods the View calls (e.g. `login()`), never events.
/// - Publish new immutable state with [setState].
/// - Keep them free of `BuildContext` and Flutter widget imports.
abstract class ViewModel<S> extends Cubit<S> {
  ViewModel(super.initialState);

  /// Current immutable state. Alias of [state] so subclasses and the rest of
  /// the app never reference the underlying library's property name directly.
  S get currentState => state;

  /// Publishes a new immutable [next] state to listeners.
  ///
  /// Use this instead of the library-specific emit/refresh/observable call so
  /// that swapping state-management implementations stays contained to this
  /// folder.
  void setState(S next) => emit(next);
}
