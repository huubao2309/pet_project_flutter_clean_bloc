import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_model.dart';

/// Rebuilds [builder] whenever the [VM]'s state changes.
///
/// Wraps the library-specific reactive builder (today `BlocBuilder`). Pages
/// depend on this widget, not on `flutter_bloc`.
class ViewModelBuilder<VM extends ViewModel<S>, S> extends StatelessWidget {
  const ViewModelBuilder({
    required this.builder,
    this.buildWhen,
    super.key,
  });

  final Widget Function(BuildContext context, S state) builder;
  final bool Function(S previous, S current)? buildWhen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VM, S>(buildWhen: buildWhen, builder: builder);
  }
}
