import 'package:flutter/material.dart';

import '../screens/account/account_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/shopping/shopping_screen.dart';
import '../screens/wishlist/wishlist_screen.dart';
import '../widgets/common/app_bottom_bar.dart';

class RootShell extends StatefulWidget {
  const RootShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  late int _currentIndex;
  final PageStorageBucket _bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(key: PageStorageKey('home')),
      const ShoppingScreen(key: PageStorageKey('shopping')),
      const WishlistScreen(key: PageStorageKey('wishlist')),
      const AccountScreen(key: PageStorageKey('account')),
    ];

    final items = const [
      AppBottomBarItem(icon: Icons.home_rounded, label: 'Home'),
      AppBottomBarItem(icon: Icons.shopping_bag_outlined, label: 'Shopping'),
      AppBottomBarItem(icon: Icons.favorite_border, label: 'Wishlist'),
      AppBottomBarItem(icon: Icons.person_outline, label: 'Account'),
    ];

    return Scaffold(
      extendBody: true,
      body: PageStorage(
        bucket: _bucket,
        child: IndexedStack(index: _currentIndex, children: screens),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AppBottomBar(
          items: items,
          currentIndex: _currentIndex,
          onChanged: _onTabChanged,
        ),
      ),
    );
  }
}
