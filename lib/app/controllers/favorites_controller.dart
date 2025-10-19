import 'package:flutter/foundation.dart';

import '../../data/local/local_storage.dart';

class FavoritesController extends ChangeNotifier {
  FavoritesController(this._storage) {
    _favorites = {..._storage.favorites};
  }

  final LocalStorage _storage;
  late Set<String> _favorites;

  Set<String> get favorites => _favorites;

  bool isFavorite(String id) => _favorites.contains(id);

  Future<void> toggleFavorite(String id) async {
    if (_favorites.contains(id)) {
      _favorites.remove(id);
    } else {
      _favorites.add(id);
    }
    await _storage.saveFavorites(_favorites.toList());
    notifyListeners();
  }
}
