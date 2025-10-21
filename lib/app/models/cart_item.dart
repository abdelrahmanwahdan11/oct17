class CartItem {
  const CartItem({
    required this.productId,
    required this.size,
    required this.quantity,
  });

  final String productId;
  final String size;
  final int quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      productId: productId,
      size: size,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'size': size,
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'] as String,
      size: json['size'] as String,
      quantity: json['quantity'] as int,
    );
  }

  @override
  int get hashCode => Object.hash(productId, size);

  @override
  bool operator ==(Object other) {
    return other is CartItem && other.productId == productId && other.size == size;
  }
}
