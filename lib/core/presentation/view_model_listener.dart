import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_model.dart';

/// Runs [listener] for side effects (navigation, snackbars, dialogs) on each
/// state change, without rebuilding its [child].
///
/// Wraps the library-specific listener (today `BlocListener`). Pages depend on
/// this widget, not on `flutter_bloc`.
class ViewModelListener<VM extends ViewModel<S>, S> extends StatelessWidget {
  const ViewModelListener({
    required this.listener,
    required this.child,
    this.listenWhen,
    super.key,
  });

  final void Function(BuildContext context, S state) listener;
  final bool Function(S previous, S current)? listenWhen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<VM, S>(
      listenWhen: listenWhen,
      listener: listener,
      child: child,
    );
  }
}
