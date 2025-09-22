import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/order.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/utils/api_routes.dart';

class ApiService {
  // List of categories
  static Future<List<Category>> fetchCategories() async {
    final res = await http.get(Uri.parse(ApiRoutes.allCategoryApi));
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> catdata = json['categories'];

      return catdata.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Categories...');
    }
  }

  // Random Products
  static Future<List<Category>> fetchRandomCategories() async {
    final res = await http.get(Uri.parse(ApiRoutes.randomProductsApi));
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> catdata = json['categories'];

      return catdata.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Categories...');
    }
  }

  // Random Category Product Detail
  static Future<List<Product>> fetchRandomCategoryProduct(
    String categoryId,
  ) async {
    final res = await http.get(
      Uri.parse('${ApiRoutes.randomCategoryProductApi}/$categoryId'),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> productsData = json['products'];
      return productsData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products for category');
    }
  }

  // List of All Products
  static Future<List<Product>> fetchAllProducts() async {
    final res = await http.get(Uri.parse(ApiRoutes.allProductsApi));

    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      return jsonList.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load all products');
    }
  }

  // List of Random products
  static Future<List<Product>> fetchRandomProducts() async {
    final res = await http.get(Uri.parse(ApiRoutes.randomProducts));
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> productsData = json['products'];

      return productsData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Products...');
    }
  }

  // List of Top Rated Products
  static Future<List<Product>> fetchTopSaleProducs() async {
    final res = await http.get(Uri.parse(ApiRoutes.topSellingProductsApi));

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> topSaleProductsData = json['products'];

      return topSaleProductsData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Products...');
    }
  }

  // Product Detail
  static Future<Product> fetchProductDetails(String productId) async {
    final response = await http.get(
      Uri.parse('${ApiRoutes.productDetailApi}/$productId'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Product.fromJson(json);
    } else {
      throw Exception('Failed to load product details');
    }
  }

  // List of Products by Category
  static Future<List<Product>> fetchProductsByCategory(
    String categoryId,
  ) async {
    final res = await http.get(
      Uri.parse('${ApiRoutes.productByCategoryApi}/$categoryId'),
    );
    if (res.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(res.body);
      //final List<dynamic> productsData = json['products'];
      return jsonList.map((item) => Product.fromJson(item)).toList();
    } else {
      print('Error: $e');
      throw Exception('Error: $e');
    }
  }

  // Search Products
  static Future<List<Product>> fetchProducts({
    required String productName,
    required String categoryId,
  }) async {
    final res = await http.get(
      Uri.parse(
        '${ApiRoutes.searchProductApi}?product_name=$productName&category_id=$categoryId',
      ),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> productsData = json['products'];
      return productsData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  // For placing order
  static Future<Map<String, dynamic>> placeOrder(Order order) async {
    final response = await http.post(
      Uri.parse(ApiRoutes.placeOrderApi),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(order.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception(
        'Failed to place order. Status code: ${response.statusCode}',
      );
    }
  }

  // For tracking order
  static Future<List<Order>> trackOrder(String phone) async {
    final response = await http.get(
      Uri.parse('${ApiRoutes.trackOrderApi}/phone?phone=$phone'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['success'] == true) {
        final List ordersJson = json['orders'] as List;

        final orders = ordersJson.map((e) {
          try {
            return Order.fromJson(e);
          } catch (e) {
            rethrow;
          }
        }).toList();

        return orders;
      } else {
        return [];
      }
    } else {
      throw Exception(
        'Failed to track order. Status: ${response.statusCode}, '
        'Response: ${response.body}',
      );
    }
  }
}
