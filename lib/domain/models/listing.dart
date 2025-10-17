import 'package:flutter/foundation.dart';

@immutable
class Listing {
  const Listing({
    required this.id,
    required this.titleAr,
    required this.titleEn,
    required this.descriptionAr,
    required this.descriptionEn,
    required this.images,
    required this.price,
    required this.rating,
    required this.tags,
    required this.gearbox,
    required this.fuel,
    required this.seats,
  });

  final String id;
  final String titleAr;
  final String titleEn;
  final String descriptionAr;
  final String descriptionEn;
  final List<String> images;
  final double price;
  final double rating;
  final List<String> tags;
  final String gearbox;
  final String fuel;
  final int seats;

  String titleForLocale(String code) => code == 'ar' ? titleAr : titleEn;
  String descriptionForLocale(String code) => code == 'ar' ? descriptionAr : descriptionEn;

  Listing copyWith({
    double? price,
    double? rating,
    List<String>? tags,
  }) {
    return Listing(
      id: id,
      titleAr: titleAr,
      titleEn: titleEn,
      descriptionAr: descriptionAr,
      descriptionEn: descriptionEn,
      images: images,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      gearbox: gearbox,
      fuel: fuel,
      seats: seats,
    );
  }

  factory Listing.fromJson(Map<String, dynamic> json) {
    final title = json['title'] as Map<String, dynamic>? ?? const {};
    final description = json['description'] as Map<String, dynamic>? ?? const {};
    return Listing(
      id: json['id'] as String,
      titleAr: title['ar'] as String? ?? '',
      titleEn: title['en'] as String? ?? '',
      descriptionAr: description['ar'] as String? ?? '',
      descriptionEn: description['en'] as String? ?? '',
      images: List<String>.from(json['images'] as List<dynamic>? ?? const <String>[]),
      price: (json['price'] as num?)?.toDouble() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      tags: List<String>.from(json['tags'] as List<dynamic>? ?? const <String>[]),
      gearbox: json['gearbox'] as String? ?? '',
      fuel: json['fuel'] as String? ?? '',
      seats: (json['seats'] as num?)?.toInt() ?? 0,
    );
  }
}
