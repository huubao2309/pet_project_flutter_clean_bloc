import 'package:flutter/material.dart';
import 'package:benny_style/benny_locator.dart';
import 'package:benny_style/buttons/base_button_type.dart';
import 'package:benny_style/buttons/benny_primary_button.dart';
import 'package:benny_style/buttons/benny_secondary_button.dart';
import 'package:benny_style/selection_dial/selection_config.dart';
import 'package:benny_style/theme/theme_state.dart';

class BennySelectionDial extends StatefulWidget {
  final List<SelectionConfig> items;
  final String? title;
  final Function(List<int>)? onConfirm;
  final double? itemHeight;
  final int? numItemDisplay;

  const BennySelectionDial({
    required this.items,
    this.title,
    this.onConfirm,
    this.itemHeight = 36,
    this.numItemDisplay = 5,
    super.key,
  });

  @override
  State<BennySelectionDial> createState() => _BennySelectionDialState();
}

class _BennySelectionDialState extends State<BennySelectionDial> {
  late List<int> selectedIndices;
  final theme = bennyLocator<ThemeState>();
  late final int _numItemDisplay;
  @override
  void initState() {
    _numItemDisplay = widget.numItemDisplay ?? 5;
    super.initState();
    selectedIndices = widget.items.map((wheel) => wheel.initialItem).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.all(theme.spacing.spacing16),
            child: Text(
              widget.title!,
              style: theme.textStyle.heading,
            ),
          ),
        Container(
          margin: EdgeInsets.only(bottom: theme.spacing.spacing16),
          child: Stack(
            children: [
              // Static selection box
              Positioned.fill(
                child: Center(
                  child: Container(
                    height: widget.itemHeight,
                    margin: EdgeInsets.symmetric(
                        horizontal: theme.spacing.spacing16),
                    decoration: BoxDecoration(
                      color: theme.colors.generalBorder,
                      borderRadius: BorderRadius.circular(
                          theme.borderRadius.borderRadius8),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (widget.itemHeight! * _numItemDisplay),
                child: Row(
                  children: List.generate(widget.items.length, (wheelIndex) {
                    return Expanded(
                      child: ListWheelScrollView(
                        squeeze: 1,
                        controller: FixedExtentScrollController(
                          initialItem: widget.items[wheelIndex].initialItem,
                        ),
                        itemExtent: widget.itemHeight!,
                        physics: const FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedIndices[wheelIndex] = index;
                          });
                          widget.items[wheelIndex].onSelectedItemChanged
                              ?.call(index);
                        },
                        children: widget.items[wheelIndex].items.map((item) {
                          return Center(
                            child: Text(
                              item,
                              style: theme.textStyle.paragraphDefault,
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: theme.colors.generalBorder),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(theme.spacing.spacing16),
            child: Row(
              children: [
                BennySecondaryButton(
                  title: 'Cancel',
                  type: BaseButtonType.neutral,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  isWrapContent: true,
                ),
                SizedBox(width: theme.spacing.spacing8),
                Expanded(
                  child: BennyPrimaryButton(
                    type: BaseButtonType.neutral,
                    title: 'Confirm',
                    onPressed: () {
                      widget.onConfirm?.call(selectedIndices);
                      Navigator.pop(context, selectedIndices);
                    },
                    isWrapContent: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
