import 'package:flutter/foundation.dart';

class SettingsViewModel extends ChangeNotifier {
  bool pushNotifications = true;

  void togglePush(bool value) {
    pushNotifications = value;
    notifyListeners();
  }
}
