import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

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
              color: isActive ? AppColors.orange : AppColors.border,
            ),
          ),
          selectedColor: AppColors.orangeSoft,
          labelStyle: TextStyle(
            color: isActive ? AppColors.orange : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        );
      }).toList(),
    );
  }
}
