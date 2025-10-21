import '../services/local_storage_service.dart';

class WishlistRepository {
  WishlistRepository({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;
  static const String _storageKey = 'wishlist_v1';

  Future<List<String>> loadFavorites() async {
    return storage.getStringList(_storageKey);
  }

  Future<void> saveFavorites(List<String> ids) async {
    if (ids.isEmpty) {
      await storage.remove(_storageKey);
      return;
    }
    await storage.setStringList(_storageKey, ids);
  }
}
