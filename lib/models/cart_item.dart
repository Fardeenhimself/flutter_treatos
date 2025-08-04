class CartItem {
  final String id; // This is product id
  final String productName;
  final String salePrice;
  final String productImage;
  int quantity;

  CartItem({
    required this.id,
    required this.productName,
    required this.salePrice,
    required this.productImage,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'salePrice': salePrice,
      'productImage': productImage,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productName: map['productName'],
      salePrice: map['salePrice'],
      productImage: map['productImage'],
      quantity: map['quantity'],
    );
  }
}
