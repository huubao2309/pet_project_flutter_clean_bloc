import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'view_model.dart';

/// Provides a [ViewModel] to the widget subtree.
///
/// Wraps the library-specific provider (today `BlocProvider`). Pages depend on
/// this widget, not on `flutter_bloc`, so migrating state-management libraries
/// is contained to this folder.
class ViewModelProvider<VM extends ViewModel<dynamic>> extends StatelessWidget {
  const ViewModelProvider({
    required this.create,
    required this.child,
    super.key,
  });

  final VM Function(BuildContext context) create;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VM>(create: create, child: child);
  }
}

/// Provides several [ViewModel]s to the same subtree.
class MultiViewModelProvider extends StatelessWidget {
  const MultiViewModelProvider({
    required this.providers,
    required this.child,
    super.key,
  });

  final List<ViewModelProvider> providers;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    Widget tree = child;
    for (final provider in providers.reversed) {
      tree = _ProviderHost(provider: provider, child: tree);
    }
    return tree;
  }
}

class _ProviderHost extends StatelessWidget {
  const _ProviderHost({required this.provider, required this.child});

  final ViewModelProvider provider;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: provider.create,
      child: child,
    );
  }
}
