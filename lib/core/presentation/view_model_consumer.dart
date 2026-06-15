import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_model.dart';

/// Combines [ViewModelBuilder] and [ViewModelListener]: rebuilds [builder] on
/// state changes while also running [listener] for side effects.
///
/// Wraps the library-specific consumer (today `BlocConsumer`). Pages depend on
/// this widget, not on `flutter_bloc`.
class ViewModelConsumer<VM extends ViewModel<S>, S> extends StatelessWidget {
  const ViewModelConsumer({
    required this.builder,
    required this.listener,
    this.buildWhen,
    this.listenWhen,
    super.key,
  });

  final Widget Function(BuildContext context, S state) builder;
  final void Function(BuildContext context, S state) listener;
  final bool Function(S previous, S current)? buildWhen;
  final bool Function(S previous, S current)? listenWhen;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VM, S>(
      buildWhen: buildWhen,
      listenWhen: listenWhen,
      listener: listener,
      builder: builder,
    );
  }
}
