import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.onPressed, this.icon, this.label});

  final VoidCallback onPressed;
  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final child = Text(label ?? '{{PRIMARY_ACTION_LABEL}}');
    if (icon == null) {
      return ElevatedButton(onPressed: onPressed, child: child);
    }
    return ElevatedButton.icon(onPressed: onPressed, icon: Icon(icon), label: child);
  }
}
