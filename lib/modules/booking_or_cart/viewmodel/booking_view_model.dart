import 'package:flutter/foundation.dart';

class BookingViewModel extends ChangeNotifier {
  DateTimeRange? range;
  int guests = 1;

  void updateRange(DateTimeRange value) {
    range = value;
    notifyListeners();
  }

  void updateGuests(int value) {
    guests = value;
    notifyListeners();
  }
}
