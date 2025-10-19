import '../../domain/models/app_notification.dart';

class NotificationRepository {
  final List<AppNotification> _notifications = <AppNotification>[];

  Future<List<AppNotification>> fetchNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<AppNotification>.unmodifiable(_notifications);
  }

  Future<void> addNotification(AppNotification notification) async {
    _notifications.insert(0, notification);
  }

  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index] = _notifications[index].copyWith(read: true);
    }
  }
}
