import 'dart:convert';

class ShippingAddress {
  const ShippingAddress({
    required this.fullName,
    required this.phone,
    required this.street,
    required this.city,
    required this.country,
  });

  final String fullName;
  final String phone;
  final String street;
  final String city;
  final String country;

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'phone': phone,
      'street': street,
      'city': city,
      'country': country,
    };
  }

  factory ShippingAddress.fromMap(Map<String, dynamic> map) {
    return ShippingAddress(
      fullName: map['fullName'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      street: map['street'] as String? ?? '',
      city: map['city'] as String? ?? '',
      country: map['country'] as String? ?? '',
    );
  }

  ShippingAddress copyWith({
    String? fullName,
    String? phone,
    String? street,
    String? city,
    String? country,
  }) {
    return ShippingAddress(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      street: street ?? this.street,
      city: city ?? this.city,
      country: country ?? this.country,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory ShippingAddress.fromJson(String source) =>
      ShippingAddress.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

class PaymentMethodInfo {
  const PaymentMethodInfo({
    required this.brand,
    required this.lastFour,
  });

  final String brand;
  final String lastFour;

  Map<String, dynamic> toMap() {
    return {
      'brand': brand,
      'lastFour': lastFour,
    };
  }

  factory PaymentMethodInfo.fromMap(Map<String, dynamic> map) {
    return PaymentMethodInfo(
      brand: map['brand'] as String? ?? '',
      lastFour: map['lastFour'] as String? ?? '',
    );
  }

  PaymentMethodInfo copyWith({String? brand, String? lastFour}) {
    return PaymentMethodInfo(
      brand: brand ?? this.brand,
      lastFour: lastFour ?? this.lastFour,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory PaymentMethodInfo.fromJson(String source) =>
      PaymentMethodInfo.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

class OrderLine {
  const OrderLine({
    required this.productId,
    required this.title,
    required this.image,
    required this.size,
    required this.quantity,
    required this.price,
  });

  final String productId;
  final String title;
  final String image;
  final String size;
  final int quantity;
  final double price;

  double get lineTotal => price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'title': title,
      'image': image,
      'size': size,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderLine.fromMap(Map<String, dynamic> map) {
    return OrderLine(
      productId: map['productId'] as String? ?? '',
      title: map['title'] as String? ?? '',
      image: map['image'] as String? ?? '',
      size: map['size'] as String? ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      price: (map['price'] as num?)?.toDouble() ?? 0,
    );
  }
}

class OrderDetail {
  const OrderDetail({
    required this.id,
    required this.createdAt,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.status,
    required this.shippingAddress,
    required this.paymentMethod,
  });

  final String id;
  final DateTime createdAt;
  final List<OrderLine> lines;
  final double subtotal;
  final double discount;
  final double total;
  final String status;
  final ShippingAddress shippingAddress;
  final PaymentMethodInfo paymentMethod;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'lines': lines.map((line) => line.toMap()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'total': total,
      'status': status,
      'shippingAddress': shippingAddress.toMap(),
      'paymentMethod': paymentMethod.toMap(),
    };
  }

  factory OrderDetail.fromMap(Map<String, dynamic> map) {
    return OrderDetail(
      id: map['id'] as String? ?? '',
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ?? DateTime.now(),
      lines: (map['lines'] as List<dynamic>? ?? [])
          .map((item) => OrderLine.fromMap(item as Map<String, dynamic>))
          .toList(),
      subtotal: (map['subtotal'] as num?)?.toDouble() ?? 0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      total: (map['total'] as num?)?.toDouble() ?? 0,
      status: map['status'] as String? ?? 'processing',
      shippingAddress: ShippingAddress.fromMap(
        (map['shippingAddress'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
      paymentMethod: PaymentMethodInfo.fromMap(
        (map['paymentMethod'] as Map<String, dynamic>? ?? <String, dynamic>{}),
      ),
    );
  }
}
