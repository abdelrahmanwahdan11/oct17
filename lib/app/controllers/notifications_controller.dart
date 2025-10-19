import 'package:flutter/foundation.dart';

import '../../data/local/notification_repository.dart';
import '../../domain/models/app_notification.dart';

class NotificationsController extends ChangeNotifier {
  NotificationsController(this._repository);

  final NotificationRepository _repository;
  final List<AppNotification> _notifications = <AppNotification>[];

  List<AppNotification> get notifications =>
      List<AppNotification>.unmodifiable(_notifications);

  Future<void> refresh() async {
    final items = await _repository.fetchNotifications();
    _notifications
      ..clear()
      ..addAll(items);
    notifyListeners();
  }

  Future<void> push(AppNotification notification) async {
    await _repository.addNotification(notification);
    _notifications.insert(0, notification);
    notifyListeners();
  }
}
