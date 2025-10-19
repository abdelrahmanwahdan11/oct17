import 'package:flutter/material.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../widgets/app_background.dart';

class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context);
    return Scaffold(
      body: OrrisoBackground(
        child: Center(
          child: Text(
            '${strings.t('general.loading')} $routeName',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ),
    );
  }
}
