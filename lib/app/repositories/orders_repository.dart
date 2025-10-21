import 'dart:convert';

import '../models/order.dart';
import '../services/local_storage_service.dart';

class OrdersRepository {
  OrdersRepository({this.storage = LocalStorageService.instance});

  final LocalStorageService storage;

  static const String _ordersKey = 'orders_v1';
  static const String _addressKey = 'orders_address_v1';
  static const String _paymentKey = 'orders_payment_v1';

  Future<List<OrderDetail>> loadOrders() async {
    final raw = await storage.getStringList(_ordersKey);
    return raw
        .map((entry) => OrderDetail.fromMap(jsonDecode(entry) as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveOrders(List<OrderDetail> orders) async {
    final payload = orders.map((order) => jsonEncode(order.toMap())).toList();
    await storage.setStringList(_ordersKey, payload);
  }

  Future<ShippingAddress?> loadAddress() async {
    final raw = await storage.getString(_addressKey);
    if (raw == null) return null;
    return ShippingAddress.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveAddress(ShippingAddress address) async {
    await storage.setString(_addressKey, jsonEncode(address.toMap()));
  }

  Future<PaymentMethodInfo?> loadPaymentMethod() async {
    final raw = await storage.getString(_paymentKey);
    if (raw == null) return null;
    return PaymentMethodInfo.fromMap(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> savePaymentMethod(PaymentMethodInfo info) async {
    await storage.setString(_paymentKey, jsonEncode(info.toMap()));
  }
}
