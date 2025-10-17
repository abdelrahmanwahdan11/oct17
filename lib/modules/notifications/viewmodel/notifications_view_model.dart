import 'package:flutter/foundation.dart';

class NotificationsViewModel extends ChangeNotifier {
  final List<String> notifications = List.generate(5, (index) => 'Notification ${index + 1}');
}
