enum NotificationType {
  outbidAlert,
  auctionEnding,
  matchAlert,
  dailySummary,
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.read = false,
  });

  final String id;
  final String userId;
  final NotificationType type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final bool read;

  AppNotification copyWith({bool? read}) {
    return AppNotification(
      id: id,
      userId: userId,
      type: type,
      payload: payload,
      createdAt: createdAt,
      read: read ?? this.read,
    );
  }
}
