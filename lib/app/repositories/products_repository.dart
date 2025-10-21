import 'dart:async';
import 'dart:math';

import '../models/product.dart';

class ProductsRepository {
  ProductsRepository() {
    _seedProducts();
  }

  final List<Product> _products = [];
  List<String>? _cachedCategories;

  void _seedProducts() {
    if (_products.isNotEmpty) return;
    const baseProducts = [
      Product(
        id: 'p1',
        title: 'Cotton T-Shirt',
        price: 86.0,
        oldPrice: 189.0,
        category: 'Tops',
        gender: 'Men',
        image: 'assets/images/men_1.png',
        gallery: [
          'assets/images/men_1.png',
          'assets/images/men_2.png',
          'assets/images/jacket.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p2',
        title: 'Ladies Top',
        price: 88.0,
        oldPrice: 150.0,
        category: 'Tops',
        gender: 'Women',
        image: 'assets/images/women_1.png',
        gallery: [
          'assets/images/women_1.png',
          'assets/images/women_2.png',
          'assets/images/dress.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p3',
        title: 'Jacket Man',
        price: 95.0,
        oldPrice: 189.0,
        category: 'Outerwear',
        gender: 'Men',
        image: 'assets/images/jacket.png',
        gallery: [
          'assets/images/jacket.png',
          'assets/images/men_1.png',
          'assets/images/hat.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p4',
        title: 'Dress Woman',
        price: 130.0,
        oldPrice: 200.0,
        category: 'Dresses',
        gender: 'Women',
        image: 'assets/images/dress.png',
        gallery: [
          'assets/images/dress.png',
          'assets/images/women_2.png',
          'assets/images/women_1.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p5',
        title: 'Orange Hoodie',
        price: 110.0,
        oldPrice: 180.0,
        category: 'Outerwear',
        gender: 'Men',
        image: 'assets/images/men_2.png',
        gallery: [
          'assets/images/men_2.png',
          'assets/images/men_1.png',
          'assets/images/jacket.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p6',
        title: 'Summer Dress',
        price: 120.0,
        oldPrice: 210.0,
        category: 'Dresses',
        gender: 'Women',
        image: 'assets/images/women_2.png',
        gallery: [
          'assets/images/women_2.png',
          'assets/images/dress.png',
          'assets/images/women_1.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p7',
        title: 'Casual Hat',
        price: 45.0,
        oldPrice: 60.0,
        category: 'Accessories',
        gender: 'Men',
        image: 'assets/images/hat.png',
        gallery: [
          'assets/images/hat.png',
          'assets/images/men_1.png',
          'assets/images/men_2.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p8',
        title: 'Sport Tee',
        price: 70.0,
        oldPrice: 120.0,
        category: 'Tops',
        gender: 'Men',
        image: 'assets/images/men_1.png',
        gallery: [
          'assets/images/men_1.png',
          'assets/images/men_2.png',
          'assets/images/jacket.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p9',
        title: 'Silk Dress',
        price: 150.0,
        oldPrice: 240.0,
        category: 'Dresses',
        gender: 'Women',
        image: 'assets/images/dress.png',
        gallery: [
          'assets/images/dress.png',
          'assets/images/women_1.png',
          'assets/images/women_2.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p10',
        title: 'Formal Shirt',
        price: 99.0,
        oldPrice: 160.0,
        category: 'Tops',
        gender: 'Men',
        image: 'assets/images/men_2.png',
        gallery: [
          'assets/images/men_2.png',
          'assets/images/men_1.png',
          'assets/images/hat.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p11',
        title: 'Casual Blazer',
        price: 140.0,
        oldPrice: 220.0,
        category: 'Outerwear',
        gender: 'Men',
        image: 'assets/images/jacket.png',
        gallery: [
          'assets/images/jacket.png',
          'assets/images/men_2.png',
          'assets/images/hat.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
      Product(
        id: 'p12',
        title: 'Evening Gown',
        price: 180.0,
        oldPrice: 260.0,
        category: 'Dresses',
        gender: 'Women',
        image: 'assets/images/dress.png',
        gallery: [
          'assets/images/dress.png',
          'assets/images/women_2.png',
          'assets/images/women_1.png',
        ],
        sizes: ['S', 'M', 'L', 'XL'],
      ),
    ];

    _products.addAll(baseProducts);
  }

  Future<List<Product>> fetchProducts({
    required int page,
    required int pageSize,
    Set<String> favoriteIds = const <String>{},
    String? category,
    String? gender,
    String? searchTerm,
    double? minPrice,
    double? maxPrice,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    Iterable<Product> filtered = _products;

    if (category != null && category.isNotEmpty && category.toLowerCase() != 'all') {
      filtered = filtered.where((product) => product.category.toLowerCase() == category.toLowerCase());
    }

    if (gender != null && gender.isNotEmpty && gender.toLowerCase() != 'all') {
      filtered = filtered.where((product) => product.gender.toLowerCase() == gender.toLowerCase());
    }

    if (searchTerm != null && searchTerm.isNotEmpty) {
      final query = searchTerm.toLowerCase();
      filtered = filtered.where((product) => product.title.toLowerCase().contains(query));
    }

    if (minPrice != null || maxPrice != null) {
      final lower = minPrice ?? double.negativeInfinity;
      final upper = maxPrice ?? double.infinity;
      filtered = filtered.where((product) => product.price >= lower && product.price <= upper);
    }

    final start = page * pageSize;
    final sliced = filtered.skip(start).take(pageSize).toList();
    return sliced
        .map(
          (product) => product.copyWith(
            isFavorite: favoriteIds.contains(product.id),
          ),
        )
        .toList();
  }

  Future<List<Product>> fetchPopular({
    int limit = 10,
    Set<String> favoriteIds = const <String>{},
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _products.take(limit).map((product) => product.copyWith(isFavorite: favoriteIds.contains(product.id))).toList();
  }

  Product? getById(String id, {Set<String> favoriteIds = const <String>{}}) {
    final product = _products.firstWhere((element) => element.id == id, orElse: () => const Product(
          id: 'not_found',
          title: 'Unknown',
          price: 0,
          oldPrice: 0,
          category: 'Unknown',
          gender: 'Unknown',
          image: 'assets/images/men_1.png',
          gallery: ['assets/images/men_1.png'],
          sizes: ['S', 'M', 'L', 'XL'],
        ));
    if (product.id == 'not_found') {
      return null;
    }
    return product.copyWith(isFavorite: favoriteIds.contains(product.id));
  }

  double get minPrice {
    if (_products.isEmpty) {
      return 0;
    }
    return _products.map((product) => product.price).reduce(min);
  }

  double get maxPrice {
    if (_products.isEmpty) {
      return 0;
    }
    return _products.map((product) => product.price).reduce(max);
  }

  List<String> get categories {
    return _cachedCategories ??= _products.map((product) => product.category).toSet().toList()..sort();
  }
}
