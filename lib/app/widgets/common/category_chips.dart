import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
                color: isActive ? Colors.transparent : AppColors.border,
              ),
            ),
            labelStyle: TextStyle(
              color: isActive ? AppColors.orange : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
            selectedColor: AppColors.orangeSoft,
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ),
    );
  }
}
