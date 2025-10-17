import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../viewmodel/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = ProfileViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        appBar: AppBar(title: Text(loc.isArabic ? 'الملف الشخصي' : 'Profile')),
        body: AnimatedBuilder(
          animation: _viewModel,
          builder: (context, _) {
            return ListView(
              padding: const EdgeInsets.all(24),
              children: [
                CircleAvatar(radius: 36, child: Text(loc.isArabic ? 'أ' : 'A')),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: Text(loc.isArabic ? 'الإشعارات' : 'Notifications'),
                  value: _viewModel.notificationsEnabled,
                  onChanged: _viewModel.toggleNotifications,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(loc.isArabic ? 'الاسم' : 'Name'),
                  subtitle: const Text('John Doe'),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(loc.isArabic ? 'اللغة' : 'Language'),
                  subtitle: Text(loc.isArabic ? 'العربية' : 'Arabic'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
