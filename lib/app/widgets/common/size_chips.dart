import 'package:flutter/material.dart';

class SizeChips extends StatelessWidget {
  const SizeChips({
    super.key,
    required this.sizes,
    required this.selected,
    required this.onSelected,
  });

  final List<String> sizes;
  final String? selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outlineVariant ?? theme.dividerColor;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sizes.map((size) {
        final isActive = size == selected;
        return ChoiceChip(
          label: Text(size),
          selected: isActive,
          onSelected: (_) => onSelected(size),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isActive
                  ? theme.colorScheme.primary
                  : outline.withOpacity(theme.brightness == Brightness.dark ? 0.4 : 1),
            ),
          ),
          selectedColor: theme.colorScheme.primary.withOpacity(0.16),
          labelStyle: TextStyle(
            color: isActive
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.6),
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}
