class Product {
  final String id;
  final String productName;
  final String salePrice;
  final String? discountPrice;
  final String? categoryName;
  final String? productImage;
  final String? quantity;
  final String? totalSold;
  final String? categoryId;

  // Constructor
  Product({
    required this.id,
    required this.productName,
    required this.salePrice,
    this.discountPrice, // might be null
    this.categoryName,
    this.productImage,
    this.quantity,
    this.totalSold, // only for top-sale-products
    this.categoryId,
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
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      quantity: json['qty'] as String?,
    );
  }
}
