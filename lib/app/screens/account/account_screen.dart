import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/locale_controller.dart';
import '../../controllers/settings_controller.dart';
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
    final settingsController = scope.settings;

    return AnimatedBuilder(
      animation: Listenable.merge([
        localeController,
        authController,
        themeController,
        settingsController,
      ]),
      builder: (context, _) {
        final user = authController.currentUser;
        final theme = Theme.of(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(localization.translate('account')),
            actions: [
              IconButton(
                onPressed: () => _showLanguageSheet(context, localization, localeController),
                icon: const Icon(Icons.language),
                tooltip: localization.translate('language'),
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
                Text(
                  localization.translate('account_settings'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.receipt_long_outlined,
                  title: localization.translate('orders_title'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pushNamed('orders'),
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.person_outline,
                  title: localization.translate('edit_profile'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showProfileSheet(context, localization, authController),
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.lock_outline,
                  title: localization.translate('change_password'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showPasswordSheet(context, localization, authController),
                ),
                const SizedBox(height: 16),
                Text(
                  localization.translate('app_preferences'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.language,
                  title: localization.translate('language'),
                  trailing: Text(
                    _languageLabel(localization, localeController.locale),
                    style: theme.textTheme.bodyMedium,
                  ),
                  onTap: () => _showLanguageSheet(context, localization, localeController),
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
                const SizedBox(height: 16),
                Text(
                  localization.translate('notifications_settings'),
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.notifications_active_outlined,
                  title: localization.translate('push_notifications'),
                  trailing: Switch.adaptive(
                    value: settingsController.pushNotifications,
                    onChanged: (value) => settingsController.updatePush(value),
                  ),
                  onTap: () =>
                      settingsController.updatePush(!settingsController.pushNotifications),
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.email_outlined,
                  title: localization.translate('email_notifications'),
                  trailing: Switch.adaptive(
                    value: settingsController.emailNotifications,
                    onChanged: (value) => settingsController.updateEmail(value),
                  ),
                  onTap: () =>
                      settingsController.updateEmail(!settingsController.emailNotifications),
                ),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.local_offer_outlined,
                  title: localization.translate('offers_notifications'),
                  trailing: Switch.adaptive(
                    value: settingsController.offersNotifications,
                    onChanged: (value) => settingsController.updateOffers(value),
                  ),
                  onTap: () => settingsController
                      .updateOffers(!settingsController.offersNotifications),
                ),
                const SizedBox(height: 16),
                Text(localization.translate('support'),
                    style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 12),
                ListTileSetting(
                  icon: Icons.support_agent,
                  title: localization.translate('contact_us'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(localization.translate('support_placeholder'))),
                    );
                  },
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
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageSheet(
    BuildContext context,
    AppLocalizations localization,
    LocaleController controller,
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
                title: Text(localization.translate('language')),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              RadioListTile<String>(
                value: 'en',
                groupValue: controller.locale.languageCode,
                title: Text(localization.translate('language_english')),
                onChanged: (value) {
                  if (value != null) controller.updateLocale(Locale(value));
                  Navigator.of(context).pop();
                },
              ),
              RadioListTile<String>(
                value: 'ar',
                groupValue: controller.locale.languageCode,
                title: Text(localization.translate('language_arabic')),
                onChanged: (value) {
                  if (value != null) controller.updateLocale(Locale(value));
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

  void _showProfileSheet(
    BuildContext context,
    AppLocalizations localization,
    AuthController controller,
  ) {
    final formKey = GlobalKey<FormState>();
    final user = controller.currentUser;
    final nameController = TextEditingController(text: user?.name ?? '');
    final emailController = TextEditingController(text: user?.email ?? '');

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localization.translate('edit_profile'),
                        style: Theme.of(context).textTheme.displaySmall),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: localization.translate('name_label'),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value.trim().length < 3) {
                      return localization.translate('validation_name_length');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: localization.translate('email_label'),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return localization.translate('validation_required');
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return localization.translate('validation_email');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        await controller.updateProfile(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localization.translate('profile_updated')),
                            ),
                          );
                        }
                      } on AuthException catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.translate(error.code))),
                        );
                      }
                    },
                    child: Text(localization.translate('save_changes')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      nameController.dispose();
      emailController.dispose();
    });
  }

  void _showPasswordSheet(
    BuildContext context,
    AppLocalizations localization,
    AuthController controller,
  ) {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(localization.translate('change_password'),
                        style: Theme.of(context).textTheme.displaySmall),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: localization.translate('current_password'),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('validation_required');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: localization.translate('new_password'),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value.length < 6) {
                      return localization.translate('validation_password_length');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: localization.translate('confirm_password_label'),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return localization.translate('validation_required');
                    }
                    if (value != newPasswordController.text) {
                      return localization.translate('validation_password_match');
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;
                      try {
                        await controller.changePassword(
                          currentPassword: currentPasswordController.text,
                          newPassword: newPasswordController.text,
                        );
                        if (context.mounted) {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(localization.translate('password_updated')),
                            ),
                          );
                        }
                      } on AuthException catch (error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localization.translate(error.code))),
                        );
                      }
                    },
                    child: Text(localization.translate('save_changes')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      currentPasswordController.dispose();
      newPasswordController.dispose();
      confirmPasswordController.dispose();
    });
  }

  String _languageLabel(AppLocalizations localization, Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return localization.translate('language_arabic');
      case 'en':
      default:
        return localization.translate('language_english');
    }
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
