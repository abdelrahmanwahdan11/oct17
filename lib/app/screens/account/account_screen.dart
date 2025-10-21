import 'package:flutter/material.dart';

import '../../controllers/locale_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../localization/app_localizations.dart';
import '../../navigation/app_scope.dart';
import '../../theme/app_colors.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/list_tile_setting.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = AppScope.of(context);
    final localeController = scope.locale;
    final authController = scope.auth;
    final themeController = scope.theme;
    final localization = AppLocalizations.of(context);

    return AnimatedBuilder(
      animation: Listenable.merge([
        localeController,
        authController,
        themeController,
      ]),
      builder: (context, _) {
        final user = authController.currentUser;
        final theme = Theme.of(context);
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
              IconButton(
                onPressed: () => _showThemeSheet(context, localization, themeController),
                icon: const Icon(Icons.dark_mode_outlined),
                tooltip: localization.translate('appearance'),
              ),
            ],
          ),
          body: responsiveConstrainedBody(
            context,
            ListView(
              padding: responsivePagePadding(context),
              children: [
                _ProfileCard(userName: user?.name, email: user?.email),
                const SizedBox(height: 16),
                Text(localization.translate('settings'), style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 12),
                ListTileSetting(
                icon: Icons.receipt_long_outlined,
                title: localization.translate('orders_title'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).pushNamed('orders'),
              ),
              const SizedBox(height: 12),
              ListTileSetting(
                icon: Icons.palette_outlined,
                title: localization.translate('appearance'),
                trailing: Text(
                  _themeLabel(localization, themeController.themeMode),
                  style: theme.textTheme.bodyMedium,
                ),
                onTap: () => _showThemeSheet(context, localization, themeController),
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
              ListTileSetting(
                icon: Icons.logout,
                title: localization.translate('logout'),
                onTap: () {
                  authController.logout();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(localization.translate('logout_success'))),
                  );
                },
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

  void _showThemeSheet(
    BuildContext context,
    AppLocalizations localization,
    ThemeController controller,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(localization.translate('appearance')),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.system,
                groupValue: controller.themeMode,
                title: Text(localization.translate('theme_system')),
                onChanged: (value) {
                  if (value != null) controller.updateThemeMode(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.light,
                groupValue: controller.themeMode,
                title: Text(localization.translate('theme_light')),
                onChanged: (value) {
                  if (value != null) controller.updateThemeMode(value);
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: controller.themeMode,
                title: Text(localization.translate('theme_dark')),
                onChanged: (value) {
                  if (value != null) controller.updateThemeMode(value);
                  Navigator.of(context).pop();
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  String _themeLabel(AppLocalizations localization, ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return localization.translate('theme_light');
      case ThemeMode.dark:
        return localization.translate('theme_dark');
      case ThemeMode.system:
        return localization.translate('theme_system');
    }
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({this.userName, this.email});

  final String? userName;
  final String? email;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.35) : Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
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
              children: [
                Text(
                  userName ?? 'Alex Richards',
                  style: theme.textTheme.displaySmall?.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 4),
                Text(
                  email ?? 'alex.richards@example.com',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.call, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}
