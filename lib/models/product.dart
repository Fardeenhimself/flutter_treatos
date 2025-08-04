class Product {
  final String id;
  final String productName;
  final String salePrice;
  final String? discountPrice;
  final String productImage;
  final String? totalSold;

  // Constructor
  Product({
    required this.id,
    required this.productName,
    required this.salePrice,
    this.discountPrice, // might be null
    required this.productImage,
    this.totalSold, // only for top-sale-products
  });

  // Convert from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      productName: json['product_name'] as String,
      salePrice: json['sale_price'] as String,
      discountPrice:
          json['discount_price']
              as String?, // if null ? dp = null : double price
      productImage: "https://pos.theabacuses.com${json['img_url']}",
      totalSold: json['total_sold'],
    );
  }
}
