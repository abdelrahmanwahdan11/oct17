import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'الإشعارات' : 'Notifications')),
        body: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ListTile(
            leading: const Icon(Icons.notifications),
            title: Text(loc.isArabic ? 'إشعار ${index + 1}' : 'Notification ${index + 1}'),
            subtitle: Text(loc.isArabic ? 'تفاصيل مختصرة' : 'Short details'),
          ),
        ),
      ),
    );
  }
}
