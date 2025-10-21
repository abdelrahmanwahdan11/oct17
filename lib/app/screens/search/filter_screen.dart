import 'package:flutter/material.dart';

import '../../controllers/products_controller.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  static const List<String> _audienceOptions = ['All', 'Men', 'Women', 'Girls'];

  late String _selectedGender;
  late String _selectedCategory;
  late RangeValues _priceRange;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final controller = AppScope.of(context).products;
    _selectedGender = controller.selectedAudience;
    _selectedCategory = controller.selectedCategory;
    _priceRange = controller.selectedPriceRange;
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final productsController = AppScope.of(context).products;
    final categories = productsController.categories;

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(localization.translate('filters')),
        actions: [
          TextButton(
            onPressed: () => _handleReset(productsController),
            child: Text(localization.translate('reset')),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          _SectionHeader(title: localization.translate('gender')),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final option in _audienceOptions)
                _FilterChip(
                  label: option,
                  isActive: _selectedGender == option,
                  onTap: () => setState(() => _selectedGender = option),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: localization.translate('category')),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final category in categories)
                _FilterChip(
                  label: category,
                  isActive: _selectedCategory == category,
                  onTap: () => setState(() => _selectedCategory = category),
                ),
            ],
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: localization.translate('price_range')),
          const SizedBox(height: 12),
          _PriceRangeView(values: _priceRange),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              activeTrackColor: AppColors.orange,
              inactiveTrackColor: AppColors.border,
              thumbColor: AppColors.orange,
            ),
            child: RangeSlider(
              values: _priceRange,
              min: productsController.minAvailablePrice,
              max: productsController.maxAvailablePrice,
              onChanged: (value) => setState(() => _priceRange = value),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () => _handleApply(productsController),
              child: Text(localization.translate('apply')),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleApply(ProductsController controller) async {
    await controller.applyFilters(
      gender: _selectedGender,
      category: _selectedCategory,
      minPrice: _priceRange.start,
      maxPrice: _priceRange.end,
    );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<void> _handleReset(ProductsController controller) async {
    setState(() {
      _selectedGender = 'All';
      _selectedCategory = 'All';
      _priceRange = RangeValues(controller.minAvailablePrice, controller.maxAvailablePrice);
    });
    await controller.resetFilters();
    if (mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.displaySmall,
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => onTap(),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: isActive ? Colors.transparent : AppColors.border),
      ),
      labelStyle: TextStyle(
        color: isActive ? AppColors.orange : AppColors.textSecondary,
        fontWeight: FontWeight.w600,
      ),
      selectedColor: AppColors.orangeSoft,
      backgroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}

class _PriceRangeView extends StatelessWidget {
  const _PriceRangeView({required this.values});

  final RangeValues values;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _Pill(text: _format(values.start)),
        _Pill(text: _format(values.end)),
      ],
    );
  }

  static String _format(double value) {
    return '${String.fromCharCode(36)}${value.toStringAsFixed(0)}';
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}
