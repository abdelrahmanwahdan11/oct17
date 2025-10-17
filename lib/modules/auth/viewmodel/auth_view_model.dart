import 'package:flutter/foundation.dart';

class AuthViewModel extends ChangeNotifier {
  bool isLoading = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    await Future<void>.delayed(const Duration(milliseconds: 400));
    isLoading = false;
    notifyListeners();
  }
}
