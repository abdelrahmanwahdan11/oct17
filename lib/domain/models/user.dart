import 'dart:convert';

class User {
  User({
    required this.id,
    required this.name,
    required this.avatar,
    required this.rating,
    required this.locale,
    this.prefs,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      rating: (json['rating'] as num).toDouble(),
      locale: json['locale'] as String? ?? 'ar',
      prefs: json['prefs'] as Map<String, dynamic>?,
    );
  }

  final String id;
  final String name;
  final String avatar;
  final double rating;
  final String locale;
  final Map<String, dynamic>? prefs;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'rating': rating,
      'locale': locale,
      if (prefs != null) 'prefs': prefs,
    };
  }

  String toRawJson() => jsonEncode(toJson());
}
