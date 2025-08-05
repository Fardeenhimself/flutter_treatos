import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/services/api_service.dart';

// For categories
final categoryProvider = FutureProvider<List<Category>>((ref) async {
  return ApiService.fetchCategories();
});

// For All products
final allProductsProvider =
    StateNotifierProvider<AllProductsNotifier, List<Product>>(
      (ref) => AllProductsNotifier(),
    );

class AllProductsNotifier extends StateNotifier<List<Product>> {
  AllProductsNotifier() : super([]) {
    _fetchNextPage();
  }

  int _currentPage = 1;
  final int _limit = 6;
  bool _isLoading = false;
  bool _hasMore = true;

  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> _fetchNextPage() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;

    try {
      final newProducts = await ApiService.fetchAllProducts(
        page: _currentPage,
        limit: _limit,
      );

      if (newProducts.length < _limit) {
        _hasMore = false;
      }

      state = [...state, ...newProducts];
      _currentPage++;
    } catch (e) {
      Center(child: Text('Error fetching more products: $e'));
    } finally {
      _isLoading = false;
    }
  }

  void loadMore() {
    _fetchNextPage();
  }
}

// For random products
final randomProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ApiService.fetchRandomProducts();
});

// For Top Sale Products
final topSaleProductsProvider = FutureProvider<List<Product>>((ref) async {
  return ApiService.fetchTopSaleProducs();
});

// For product details
final productDetailProvider = FutureProvider.family<Product, String>((
  ref,
  productId,
) async {
  return ApiService.fetchProductDetails(productId);
});
