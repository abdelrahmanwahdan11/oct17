import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class AppSearchBar extends StatefulWidget {
  const AppSearchBar({
    super.key,
    this.hintText = 'Search..',
    this.onChanged,
    this.onFilter,
    this.onVoice,
    this.initialValue,
    this.filterIcon = Icons.filter_list,
  });

  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilter;
  final VoidCallback? onVoice;
  final String? initialValue;
  final IconData filterIcon;

  @override
  State<AppSearchBar> createState() => _AppSearchBarState();
}

class _AppSearchBarState extends State<AppSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(covariant AppSearchBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          const Icon(Icons.search, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: widget.onChanged,
              decoration: InputDecoration.collapsed(hintText: widget.hintText),
            ),
          ),
          if (widget.onVoice != null)
            IconButton(
              icon: const Icon(Icons.mic, color: AppColors.textSecondary),
              onPressed: widget.onVoice,
            ),
          if (widget.onFilter != null)
            IconButton(
              icon: Icon(widget.filterIcon, color: AppColors.textSecondary),
              onPressed: widget.onFilter,
            ),
        ],
      ),
    );
  }
}
