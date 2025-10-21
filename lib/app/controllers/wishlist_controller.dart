import 'package:flutter/foundation.dart';

import '../models/product.dart';
import '../repositories/products_repository.dart';
import '../repositories/wishlist_repository.dart';

class WishlistController extends ChangeNotifier {
  WishlistController({
    required this.repository,
    required this.productsRepository,
  });

  final WishlistRepository repository;
  final ProductsRepository productsRepository;

  final Set<String> _favoriteIds = <String>{};
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Set<String> get favoriteIds => Set<String>.unmodifiable(_favoriteIds);

  List<Product> get products {
    return _favoriteIds
        .map((id) => productsRepository.getById(id, favoriteIds: _favoriteIds))
        .whereType<Product>()
        .map((product) => product.copyWith(isFavorite: true))
        .toList();
  }

  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();
    final ids = await repository.loadFavorites();
    _favoriteIds
      ..clear()
      ..addAll(ids);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      _favoriteIds.remove(productId);
    } else {
      _favoriteIds.add(productId);
    }
    await repository.saveFavorites(_favoriteIds.toList());
    notifyListeners();
  }

  Future<void> setFavorites(Set<String> ids) async {
    _favoriteIds
      ..clear()
      ..addAll(ids);
    await repository.saveFavorites(_favoriteIds.toList());
    notifyListeners();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);
}
