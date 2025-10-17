import 'package:flutter/material.dart';

import '../../core/i18n/strings.dart';

class SearchField extends StatelessWidget {
  const SearchField({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return TextField(
      decoration: InputDecoration(
        hintText: loc.t('common.search'),
        prefixIcon: const Icon(Icons.search),
      ),
      onChanged: onChanged,
    );
  }
}
