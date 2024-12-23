class OrderProduct {
  final int orderId;
  final int productId;
  final int quantity;

  OrderProduct({
    required this.orderId,
    required this.productId,
    required this.quantity,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      orderId: json['order_id'] ?? 0,
      productId: json['product_id'] ?? 0,
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'product_id': productId,
      'quantity': quantity,
    };
  }
}


class Order {
  final int orderId;
  final String userId;
  final double total;
  final String status;
  final String createdAt;
  final List<OrderProduct> products;

  Order({
    required this.orderId,
    required this.userId,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.products,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['order_id'] ?? 0,
      userId: json['user_id'].toString(),
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      products: (json['products'] as List<dynamic>?)
          ?.map((product) => OrderProduct.fromJson(product))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'user_id': userId,
      'total': total,
      'status': status,
      'created_at': createdAt,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}