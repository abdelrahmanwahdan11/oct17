import 'package:flutter/foundation.dart';

enum ViewStatus { idle, loading, error }

class LoadingState extends ChangeNotifier {
  ViewStatus status = ViewStatus.idle;
  String? error;

  void setLoading() {
    status = ViewStatus.loading;
    notifyListeners();
  }

  void setIdle() {
    status = ViewStatus.idle;
    notifyListeners();
  }

  void setError(String message) {
    error = message;
    status = ViewStatus.error;
    notifyListeners();
  }
}
