import 'package:flutter/material.dart';

class CategoryChips extends StatelessWidget {
  const CategoryChips({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final outline = theme.colorScheme.outlineVariant ?? theme.dividerColor;
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = categories[index];
          final isActive = item == selected;
          return ChoiceChip(
            label: Text(item),
            selected: isActive,
            onSelected: (_) => onSelected(item),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isActive
                    ? Colors.transparent
                    : outline.withOpacity(theme.brightness == Brightness.dark ? 0.4 : 1),
              ),
            ),
            labelStyle: TextStyle(
              color: isActive
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: FontWeight.w600,
            ),
            selectedColor: theme.colorScheme.primary.withOpacity(0.16),
            backgroundColor: theme.cardColor,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
