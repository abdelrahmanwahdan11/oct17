import 'package:flutter/material.dart';

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
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _focusNode = FocusNode();
    _focusNode.addListener(_handleFocusChanged);
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
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  void _handleFocusChanged() {
    if (!mounted) return;
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = theme.cardColor;
    final shadowBase = isDark ? 0.3 : 0.05;
    final shadowColor = Colors.black.withOpacity(_isFocused ? shadowBase + 0.12 : shadowBase);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: _isFocused ? 52 : 48,
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: _isFocused ? 18 : 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 14),
          Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.6)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: widget.onChanged,
              style: theme.textTheme.bodyLarge,
              decoration: InputDecoration.collapsed(
                hintText: widget.hintText,
                hintStyle: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.45),
                ),
              ),
            ),
          ),
          if (widget.onVoice != null)
            IconButton(
              icon: Icon(Icons.mic, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              onPressed: widget.onVoice,
            ),
          if (widget.onFilter != null)
            IconButton(
              icon: Icon(widget.filterIcon, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              onPressed: widget.onFilter,
            ),
        ],
      ),
    );
  }
}
