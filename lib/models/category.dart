class Category {
  final String id;
  final String categoryName;
  final String imageUrl;

  // Constructor
  Category({
    required this.id,
    required this.categoryName,
    required this.imageUrl,
  });

  // Convert from JSON
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      categoryName: json['category_name'] as String,
      imageUrl: json['img_url'] as String,
    );
  }
}
