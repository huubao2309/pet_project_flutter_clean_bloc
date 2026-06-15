import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_model.dart';

/// Lookup helpers for retrieving a [ViewModel] from the widget tree.
///
/// Wraps the library-specific lookups (today `context.read` / `context.watch`
/// from `flutter_bloc`'s provider). Pages call these, not `flutter_bloc`.
extension ViewModelContextX on BuildContext {
  /// Returns the nearest [VM] without subscribing to rebuilds. Use to call
  /// methods (e.g. `context.viewModel<AuthViewModel>().login(...)`).
  VM viewModel<VM extends ViewModel<dynamic>>() => read<VM>();

  /// Returns the nearest [VM] and subscribes the calling widget to rebuilds.
  VM watchViewModel<VM extends ViewModel<dynamic>>() => watch<VM>();
}
