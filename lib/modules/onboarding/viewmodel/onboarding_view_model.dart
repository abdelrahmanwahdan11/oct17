import 'package:flutter/foundation.dart';

class OnboardingViewModel extends ChangeNotifier {
  int index = 0;

  void setIndex(int value) {
    index = value;
    notifyListeners();
  }
}
