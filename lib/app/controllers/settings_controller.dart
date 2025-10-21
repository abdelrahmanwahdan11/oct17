import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

class SettingsController extends ChangeNotifier {
  SettingsController({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;

  static const _pushKey = 'settings_push_notifications_v1';
  static const _emailKey = 'settings_email_notifications_v1';
  static const _offersKey = 'settings_offers_notifications_v1';

  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _offersNotifications = true;

  bool get pushNotifications => _pushNotifications;
  bool get emailNotifications => _emailNotifications;
  bool get offersNotifications => _offersNotifications;

  Future<void> initialize() async {
    final push = await storage.getBool(_pushKey);
    final email = await storage.getBool(_emailKey);
    final offers = await storage.getBool(_offersKey);

    _pushNotifications = push ?? true;
    _emailNotifications = email ?? true;
    _offersNotifications = offers ?? true;
    notifyListeners();
  }

  Future<void> updatePush(bool value) async {
    if (_pushNotifications == value) return;
    _pushNotifications = value;
    await storage.setBool(_pushKey, value);
    notifyListeners();
  }

  Future<void> updateEmail(bool value) async {
    if (_emailNotifications == value) return;
    _emailNotifications = value;
    await storage.setBool(_emailKey, value);
    notifyListeners();
  }

  Future<void> updateOffers(bool value) async {
    if (_offersNotifications == value) return;
    _offersNotifications = value;
    await storage.setBool(_offersKey, value);
    notifyListeners();
  }
}
