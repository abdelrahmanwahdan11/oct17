import 'dart:convert';

enum RequestStatus {
  live,
  paused,
  archived,
}

class BuyRequest {
  BuyRequest({
    required this.id,
    required this.title,
    required this.category,
    required this.specs,
    required this.budget,
    required this.qty,
    required this.deadline,
    required this.location,
    required this.condition,
    required this.priority,
    required this.ownerId,
    required this.status,
  });

  factory BuyRequest.fromJson(Map<String, dynamic> json) {
    return BuyRequest(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      specs: json['specs'] as String,
      budget: (json['budget'] as num).toDouble(),
      qty: json['qty'] as int,
      deadline: DateTime.parse(json['deadline'] as String),
      location: json['location'] as String,
      condition: json['condition'] as String,
      priority: json['priority'] as String,
      ownerId: json['ownerId'] as String,
      status: RequestStatus.values.firstWhere(
        (it) => it.name == (json['status'] as String? ?? 'live'),
        orElse: () => RequestStatus.live,
      ),
    );
  }

  final String id;
  final String title;
  final String category;
  final String specs;
  final double budget;
  final int qty;
  final DateTime deadline;
  final String location;
  final String condition;
  final String priority;
  final String ownerId;
  final RequestStatus status;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'specs': specs,
      'budget': budget,
      'qty': qty,
      'deadline': deadline.toIso8601String(),
      'location': location,
      'condition': condition,
      'priority': priority,
      'ownerId': ownerId,
      'status': status.name,
    };
  }

  String toRawJson() => jsonEncode(toJson());
}
