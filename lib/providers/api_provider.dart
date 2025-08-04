import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/services/api_service.dart';

// For categories
final categoryProvider = FutureProvider<List<Category>>((ref) async {
  return ApiService.fetchCategories();
});

// For random products
final randomProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ApiService.fetchRandomProducts();
});

// For Top Sale Products
final topSaleProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ApiService.fetchTopSaleProducs();
});
