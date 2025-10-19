import 'package:flutter/material.dart';

import '../../core/theme/orriso_theme.dart';

class OrrisoBackground extends StatelessWidget {
  const OrrisoBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            OrrisoPalette.bgTop,
            OrrisoPalette.bgBottom,
          ],
        ),
      ),
      child: child,
    );
  }
}
