class Product {
  final String id;
  final String productName;
  final double salePrice;
  final double? discountPrice;
  final String productImage;

  // Constructor
  Product({
    required this.id,
    required this.productName,
    required this.salePrice,
    this.discountPrice, // might be null
    required this.productImage,
  });

  // Convert from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      salePrice: json['sale_price'] as double,
      discountPrice:
          json['discount_price'] as double?, // if null ? dp = null : double price
      productImage: json['img_url'] as String,
    );
  }
}
