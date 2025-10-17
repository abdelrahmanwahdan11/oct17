import 'package:flutter/foundation.dart';

class OrdersViewModel extends ChangeNotifier {
  final List<String> tabs = const ['active', 'past', 'cancelled'];
  int currentTab = 0;

  void setTab(int index) {
    currentTab = index;
    notifyListeners();
  }
}
