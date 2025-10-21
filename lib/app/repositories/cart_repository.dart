import 'dart:convert';

import '../models/cart_item.dart';
import '../services/local_storage_service.dart';

class CartRepository {
  CartRepository({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;
  static const String _storageKey = 'cart_v1';

  Future<List<CartItem>> loadCart() async {
    final raw = await storage.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return <CartItem>[];
    }

    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data.map((item) => CartItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  Future<void> saveCart(List<CartItem> items) async {
    if (items.isEmpty) {
      await storage.remove(_storageKey);
      return;
    }
    final encoded = jsonEncode(items.map((item) => item.toJson()).toList());
    await storage.setString(_storageKey, encoded);
  }
}
