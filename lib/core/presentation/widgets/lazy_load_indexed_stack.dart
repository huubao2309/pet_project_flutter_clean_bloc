import 'package:flutter/widgets.dart';

/// An [IndexedStack] that builds each child only the first time its index is
/// shown, then keeps it alive (preserving scroll position / state) on
/// subsequent switches. Ported from the source app's `LazyLoadIndexedStack`.
class LazyLoadIndexedStack extends StatefulWidget {
  const LazyLoadIndexedStack({
    required this.index,
    required this.children,
    this.unloadWidget = const SizedBox.shrink(),
    this.alignment = AlignmentDirectional.topStart,
    this.sizing = StackFit.loose,
    this.textDirection,
    super.key,
  });

  /// Shown for indices that have not been visited yet.
  final Widget unloadWidget;
  final AlignmentGeometry alignment;
  final StackFit sizing;
  final TextDirection? textDirection;

  /// Index of the child to show.
  final int index;
  final List<Widget> children;

  @override
  State<LazyLoadIndexedStack> createState() => _LazyLoadIndexedStackState();
}

class _LazyLoadIndexedStackState extends State<LazyLoadIndexedStack> {
  late final List<Widget> _children = widget.children
      .asMap()
      .entries
      .map((e) => e.key == widget.index ? e.value : widget.unloadWidget)
      .toList();

  @override
  void didUpdateWidget(covariant LazyLoadIndexedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Materialise the child the first time its tab becomes active.
    _children[widget.index] = widget.children[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: widget.index,
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      children: _children,
    );
  }
}
