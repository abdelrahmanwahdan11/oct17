import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';
import '../repositories/cart_repository.dart';
import '../repositories/products_repository.dart';

class CartLine {
  CartLine({required this.item, required this.product});

  final CartItem item;
  final Product product;

  double get lineTotal => product.price * item.quantity;
}

class CartController extends ChangeNotifier {
  CartController({
    required this.repository,
    required this.productsRepository,
  });

  final CartRepository repository;
  final ProductsRepository productsRepository;

  final List<CartItem> _items = <CartItem>[];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<CartItem> get rawItems => List<CartItem>.unmodifiable(_items);

  List<CartLine> get lines {
    return _items
        .map((item) {
          final product = productsRepository.getById(item.productId);
          if (product == null) return null;
          return CartLine(item: item, product: product);
        })
        .whereType<CartLine>()
        .toList();
  }

  double get subtotal => lines.fold(0, (sum, line) => sum + line.lineTotal);
  double get discount => 0;
  double get total => subtotal - discount;

  Future<void> loadCart() async {
    _isLoading = true;
    notifyListeners();
    final data = await repository.loadCart();
    _items
      ..clear()
      ..addAll(data);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    await repository.saveCart(_items);
  }

  Future<void> addToCart(Product product, {required String size, int quantity = 1}) async {
    if (size.isEmpty) return;
    final index = _items.indexWhere((item) => item.productId == product.id && item.size == size);
    if (index >= 0) {
      final existing = _items[index];
      final newQty = (existing.quantity + quantity).clamp(1, 10).toInt();
      _items[index] = existing.copyWith(quantity: newQty);
    } else {
      _items.add(
        CartItem(productId: product.id, size: size, quantity: quantity.clamp(1, 10).toInt()),
      );
    }
    await _persist();
    notifyListeners();
  }

  Future<void> removeItem(CartItem item) async {
    _items.remove(item);
    await _persist();
    notifyListeners();
  }

  Future<void> updateQuantity(CartItem item, int quantity) async {
    final index = _items.indexOf(item);
    if (index == -1) return;
    final clamped = quantity.clamp(1, 10).toInt();
    _items[index] = _items[index].copyWith(quantity: clamped);
    await _persist();
    notifyListeners();
  }

  Future<void> clear() async {
    _items.clear();
    await _persist();
    notifyListeners();
  }
}
