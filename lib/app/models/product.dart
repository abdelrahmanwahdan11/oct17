class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.category,
    required this.gender,
    required this.image,
    required this.gallery,
    required this.sizes,
    this.isFavorite = false,
    this.description = 'A cotton T-shirt is a must-have for your wardrobe.',
  });

  final String id;
  final String title;
  final double price;
  final double oldPrice;
  final String category;
  final String gender;
  final String image;
  final List<String> gallery;
  final List<String> sizes;
  final bool isFavorite;
  final String description;

  Product copyWith({
    bool? isFavorite,
  }) {
    return Product(
      id: id,
      title: title,
      price: price,
      oldPrice: oldPrice,
      category: category,
      gender: gender,
      image: image,
      gallery: gallery,
      sizes: sizes,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'oldPrice': oldPrice,
      'category': category,
      'gender': gender,
      'image': image,
      'gallery': gallery,
      'sizes': sizes,
      'isFavorite': isFavorite,
      'description': description,
    };
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      oldPrice: (json['oldPrice'] as num).toDouble(),
      category: json['category'] as String,
      gender: json['gender'] as String,
      image: json['image'] as String,
      gallery: (json['gallery'] as List<dynamic>).cast<String>(),
      sizes: (json['sizes'] as List<dynamic>).cast<String>(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      description: json['description'] as String? ?? 'A cotton T-shirt is a must-have for your wardrobe.',
    );
  }
}
