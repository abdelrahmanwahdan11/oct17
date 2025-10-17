import 'package:flutter/material.dart';

import '../../../core/i18n/strings.dart';
import '../../home/view/home_screen.dart';
import '../../orders/view/orders_screen.dart';
import '../../profile/view/profile_screen.dart';
import '../../search/view/search_screen.dart';
import '../../notifications/view/notifications_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.onNavigate});

  final void Function(String location) onNavigate;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  List<_NavItem> _items(AppLocalizations loc) => [
        const _NavItem('home', Icons.home_rounded, 'Home', HomeScreen()),
        const _NavItem('search', Icons.search_rounded, 'Search', SearchScreen()),
        const _NavItem('inbox', Icons.chat_bubble_rounded, 'Inbox', NotificationsScreen()),
        const _NavItem('orders', Icons.calendar_month_rounded, 'Trips', OrdersScreen()),
        const _NavItem('profile', Icons.person_rounded, 'Profile', ProfileScreen()),
      ];

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    final media = MediaQuery.of(context);
    final isWide = media.size.width >= 900;
    final items = _items(loc);

    final nav = isWide
        ? NavigationRail(
            selectedIndex: _index,
            onDestinationSelected: (value) => setState(() => _index = value),
            destinations: [
              for (final item in items)
                NavigationRailDestination(
                  icon: Icon(item.icon),
                  label: Text(item.labelForLocale(loc)),
                )
            ],
          )
        : _BottomNavBar(
            currentIndex: _index,
            items: items,
            onTap: (value) => setState(() => _index = value),
          );

    return Directionality(
      textDirection: loc.textDirection,
      child: Scaffold(
        extendBody: true,
        body: SafeArea(
          child: Row(
            children: [
              if (isWide) nav,
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: items[_index].content,
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: isWide ? null : nav,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => widget.onNavigate('/booking'),
          icon: const Icon(Icons.arrow_forward),
          label: Text(loc.t('common.book_now')),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem(this.key, this.icon, this.labelEn, this.content);

  final String key;
  final IconData icon;
  final String labelEn;
  final Widget content;

  String labelForLocale(AppLocalizations loc) {
    switch (key) {
      case 'home':
        return loc.isArabic ? 'الرئيسية' : 'Home';
      case 'search':
        return loc.t('common.search', fallback: 'Search');
      case 'profile':
        return loc.isArabic ? 'الملف' : 'Profile';
      case 'orders':
        return loc.isArabic ? 'الرحلات' : 'Trips';
      case 'inbox':
        return loc.isArabic ? 'الرسائل' : 'Inbox';
      default:
        return labelEn;
    }
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar({
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  final int currentIndex;
  final List<_NavItem> items;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final loc = Localizations.of<AppLocalizations>(context, AppLocalizations)!;
    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        items: [
          for (final item in items)
            BottomNavigationBarItem(
              icon: Icon(item.icon),
              label: item.labelForLocale(loc),
            )
        ],
      ),
    );
  }
}
