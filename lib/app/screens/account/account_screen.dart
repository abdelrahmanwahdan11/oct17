import 'package:flutter/material.dart';

import '../../controllers/locale_controller.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/list_tile_setting.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final localeController = scope.locale;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: localeController,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('account')),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.language),
                onSelected: (value) => localeController.updateLocale(Locale(value)),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'en', child: Text('English')),
                  const PopupMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            children: [
              _ProfileCard(),
              const SizedBox(height: 16),
              Text(localization.translate('settings'), style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 12),
              const ListTileSetting(
                icon: Icons.account_circle,
                title: 'Account Details',
                trailing: Icon(Icons.chevron_right),
              ),
              const SizedBox(height: 12),
              const ListTileSetting(
                icon: Icons.notifications,
                title: 'Notifications',
                trailing: Icon(Icons.chevron_right),
              ),
              const SizedBox(height: 12),
              const ListTileSetting(
                icon: Icons.email_outlined,
                title: 'Email',
                trailing: Icon(Icons.chevron_right),
              ),
              const SizedBox(height: 12),
              const ListTileSetting(
                icon: Icons.location_on_outlined,
                title: 'Location Services',
                trailing: Icon(Icons.chevron_right),
              ),
              const SizedBox(height: 12),
              const ListTileSetting(
                icon: Icons.logout,
                title: 'Log Out',
              ),
              const SizedBox(height: 24),
              Text(localization.translate('support'), style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 12),
              const ListTileSetting(
                icon: Icons.support_agent,
                title: 'Contact Us',
                trailing: Icon(Icons.chevron_right),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 34,
            backgroundImage: AssetImage('assets/images/avatar_alex.png'),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Alex Richards', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                SizedBox(height: 4),
                Text('alex.richards@example.com', style: TextStyle(color: AppColors.textSecondary)),
              ],
            ),
          ),
          IconButton(onPressed: () {}, icon: const Icon(Icons.call, color: AppColors.orange)),
        ],
      ),
    );
  }
}
