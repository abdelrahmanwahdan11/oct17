import 'package:flutter/foundation.dart';

class ProfileViewModel extends ChangeNotifier {
  bool notificationsEnabled = true;

  void toggleNotifications(bool value) {
    notificationsEnabled = value;
    notifyListeners();
  }
}
