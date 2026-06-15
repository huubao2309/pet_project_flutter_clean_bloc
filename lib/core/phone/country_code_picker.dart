import 'package:benny_style/bottom_sheet/benny_bottom_sheet.dart';
import 'package:benny_style/textfields/benny_search_textfield.dart';
import 'package:benny_style/theme/theme_state.dart';
import 'package:flutter/material.dart';

import '../di/injection.dart';
import 'country_phone_validator.dart';

/// Bottom-sheet country dial-code picker. De-GetX'd port of the source
/// `CountryCodeBottomSheet`, using [BennyBottomSheet] + [BennySearchTextField].
class CountryCodePicker extends StatefulWidget {
  const CountryCodePicker({
    required this.onSelected,
    this.selectedDialCode,
    super.key,
  });

  final String? selectedDialCode;
  final ValueChanged<Country> onSelected;

  /// Opens the picker as a modal bottom sheet.
  static void show({
    required ValueChanged<Country> onSelected,
    String? selectedDialCode,
  }) {
    BennyBottomSheet.show(
      content: CountryCodePicker(
        onSelected: onSelected,
        selectedDialCode: selectedDialCode,
      ),
    );
  }

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  final _searchController = TextEditingController();
  late List<Country> _filtered = List<Country>.from(countries);

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filter(String query) {
    final q = query.trim().toLowerCase();
    setState(() {
      _filtered = q.isEmpty
          ? List<Country>.from(countries)
          : countries
              .where(
                (c) =>
                    c.name.toLowerCase().contains(q) ||
                    c.dialCode.toLowerCase().contains(q),
              )
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = getIt<ThemeState>();

    return Padding(
      padding: EdgeInsets.all(theme.spacing.spacing20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BennySearchTextField(
            controller: _searchController,
            hintText: 'E.g: +32',
            onTextChanged: _filter,
          ),
          SizedBox(height: theme.spacing.spacing12),
          SizedBox(
            height: 360,
            child: ListView.separated(
              itemCount: _filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final country = _filtered[index];
                final isSelected =
                    widget.selectedDialCode == country.dialCode;
                return InkWell(
                  onTap: () {
                    widget.onSelected(country);
                    Navigator.pop(context);
                  },
                  child: Container(
                    color: isSelected
                        ? theme.colors.neutral100
                        : Colors.transparent,
                    padding: EdgeInsets.all(theme.spacing.spacing8),
                    child: Row(
                      children: [
                        SizedBox(width: 72, child: Text(country.dialCode)),
                        SizedBox(width: theme.spacing.spacing8),
                        Expanded(child: Text(country.name)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
