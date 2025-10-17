import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class AdminStubScreen extends StatelessWidget {
  const AdminStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'لوحة الإدارة' : 'Admin dashboard')),
        body: Center(
          child: Text(loc.isArabic
              ? 'هذه واجهة تحضيرية للإدارة.'
              : 'This is a placeholder admin dashboard.'),
        ),
      ),
    );
  }
}
