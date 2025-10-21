import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/order.dart';
import '../repositories/orders_repository.dart';
import 'cart_controller.dart';

class OrdersController extends ChangeNotifier {
  OrdersController({
    required this.repository,
  })  : _shippingAddress = const ShippingAddress(
          fullName: 'Alex Richards',
          phone: '+1 555-0134',
          street: '123 Fashion Avenue',
          city: 'New York, NY',
          country: 'USA',
        ),
        _paymentMethod = const PaymentMethodInfo(brand: 'Visa', lastFour: '4242');

  final OrdersRepository repository;

  final List<OrderDetail> _orders = <OrderDetail>[];
  ShippingAddress _shippingAddress;
  PaymentMethodInfo _paymentMethod;

  bool _isLoading = false;
  bool _isPlacingOrder = false;

  bool get isLoading => _isLoading;
  bool get isPlacingOrder => _isPlacingOrder;
  List<OrderDetail> get orders => List<OrderDetail>.unmodifiable(_orders);
  ShippingAddress get shippingAddress => _shippingAddress;
  PaymentMethodInfo get paymentMethod => _paymentMethod;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final loadedOrders = await repository.loadOrders();
    loadedOrders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    final loadedAddress = await repository.loadAddress();
    final loadedPayment = await repository.loadPaymentMethod();

    _orders
      ..clear()
      ..addAll(loadedOrders);
    _shippingAddress = loadedAddress ?? _shippingAddress;
    _paymentMethod = loadedPayment ?? _paymentMethod;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateShippingAddress(ShippingAddress address) async {
    _shippingAddress = address;
    await repository.saveAddress(address);
    notifyListeners();
  }

  Future<void> updatePaymentMethod(PaymentMethodInfo method) async {
    _paymentMethod = method;
    await repository.savePaymentMethod(method);
    notifyListeners();
  }

  Future<OrderDetail?> placeOrder({
    required List<CartLine> cartLines,
    double discount = 0,
  }) async {
    if (cartLines.isEmpty || _isPlacingOrder) {
      return null;
    }

    _isPlacingOrder = true;
    notifyListeners();

    try {
      final subtotal = cartLines.fold<double>(0, (sum, line) => sum + line.lineTotal);
      final appliedDiscount = min(discount, subtotal);
      final total = subtotal - appliedDiscount;
      final now = DateTime.now();
      final orderId = 'ORD-${now.millisecondsSinceEpoch}';

      final order = OrderDetail(
        id: orderId,
        createdAt: now,
        lines: cartLines
            .map(
              (line) => OrderLine(
                productId: line.product.id,
                title: line.product.title,
                image: line.product.image,
                size: line.item.size,
                quantity: line.item.quantity,
                price: line.product.price,
              ),
            )
            .toList(),
        subtotal: subtotal,
        discount: appliedDiscount,
        total: total,
        status: 'processing',
        shippingAddress: _shippingAddress,
        paymentMethod: _paymentMethod,
      );

      _orders.insert(0, order);
      await repository.saveOrders(_orders);
      return order;
    } finally {
      _isPlacingOrder = false;
      notifyListeners();
    }
  }
}
