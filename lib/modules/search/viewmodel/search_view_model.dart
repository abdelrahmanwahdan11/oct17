import 'package:flutter/foundation.dart';

class SearchViewModel extends ChangeNotifier {
  String query = '';

  void updateQuery(String value) {
    query = value;
    notifyListeners();
  }
}
