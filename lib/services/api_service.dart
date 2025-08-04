import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/product.dart';

class ApiService {
  // List of categories
  static Future<List<Category>> fetchCategories() async {
    final res = await http.get(
      Uri.parse('https://pos.theabacuses.com/api/category'),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> catdata = json['categories'];

      return catdata.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Categories...');
    }
  }

  // List of products
  static Future<List<Product>> fetchRandomProducts() async {
    final res = await http.get(
      Uri.parse('https://pos.theabacuses.com/api/random-products'),
    );
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
    final res = await http.get(
      Uri.parse('https://pos.theabacuses.com/api/top-sale-products'),
    );

    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> topSaleProductsData = json['products'];

      return topSaleProductsData.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Products...');
    }
  }
}
