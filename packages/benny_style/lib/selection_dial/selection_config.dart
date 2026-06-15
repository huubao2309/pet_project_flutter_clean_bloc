class SelectionConfig {
  final List<String> items;
  final String? title;
  final int initialItem;
  final Function(int)? onSelectedItemChanged;

  SelectionConfig({
    required this.items,
    this.title,
    this.initialItem = 0,
    this.onSelectedItemChanged,
  });
}
