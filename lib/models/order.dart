class Order {
  final String? orderId;
  final String phone;
  final String name;
  final String address;
  final double subtotal;
  final String shippingMethod;
  final double shippingCost;
  final double total;
  final String? notes;
  final List<OrderProduct> products;
  final String? status;
  final String? createdAt;

  Order({
    this.orderId,
    required this.phone,
    required this.name,
    required this.address,
    required this.subtotal,
    required this.shippingMethod,
    required this.shippingCost,
    required this.total,
    this.notes,
    required this.products,
    this.status,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'name': name,
      'address': address,
      'subtotal': subtotal,
      'shipping_method': shippingMethod,
      'shipping_cost': shippingCost,
      'total': total,
      'notes': notes,
      'products': products.map((product) => product.toJson()).toList(),
      'platform': 'app',
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['id']?.toString(),
      phone: json['phone'] ?? '', // Or make nullable in the model
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      subtotal: double.tryParse(json['subtotal'].toString()) ?? 0.0,
      shippingMethod: json['shipping_method'] ?? '',
      shippingCost: double.tryParse(json['shipping_cost'].toString()) ?? 0.0,
      total: double.tryParse(json['total'].toString()) ?? 0.0,
      notes: json['notes'],
      products: (json['products'] as List<dynamic>? ?? [])
          .map((p) => OrderProduct.fromJson(p))
          .toList(),
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}

class OrderProduct {
  final String id;
  final String productName;
  final int quantity;
  final double salePrice;
  final double totalPrice;

  OrderProduct({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.salePrice,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_name': productName,
      'quantity': quantity,
      'sale_price': salePrice,
      'total_price': totalPrice,
    };
  }

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['id']?.toString() ?? '', // fallback
      productName: json['product_name'] ?? '',
      quantity: int.tryParse(json['quantity'].toString()) ?? 0,
      salePrice: double.tryParse(json['price'].toString()) ?? 0.0,
      totalPrice: double.tryParse(json['total'].toString()) ?? 0.0,
    );
  }
}
