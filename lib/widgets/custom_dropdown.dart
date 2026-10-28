import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final String? Function(String?)? validator;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFieldTapRegion(
      child: DropdownButtonFormField<String>(
        initialValue: value,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
        items: items
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
      ),
    );
  }
}
