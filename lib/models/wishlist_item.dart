class WishlistItem {
  final String id;
  final String productName;
  final String productImage;
  final String salePrice;

  WishlistItem({
    required this.id,
    required this.productName,
    required this.productImage,
    required this.salePrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'productImage': productImage,
      'salePrice': salePrice,
    };
  }

  factory WishlistItem.fromMap(Map<String, dynamic> map) {
    return WishlistItem(
      id: map['id'],
      productName: map['productName'],
      productImage: map['productImage'],
      salePrice: map['salePrice'],
    );
  }
}
