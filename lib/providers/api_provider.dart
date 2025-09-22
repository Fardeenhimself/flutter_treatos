import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/order.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/services/api_service.dart';

// For categories
final categoryProvider = FutureProvider<List<Category>>((ref) async {
  return ApiService.fetchCategories();
});

// Random categories
final randomCategoryProvider = FutureProvider<List<Category>>((ref) async {
  return ApiService.fetchRandomCategories();
});

// For products by random category
final randomProductsByCategoryProvider =
    FutureProvider.family<List<Product>, String>((ref, categoryId) async {
      return ApiService.fetchRandomCategoryProduct(categoryId);
    });

// For All products
final allProductsProvider =
    StateNotifierProvider<AllProductsNotifier, List<Product>>(
      (ref) => AllProductsNotifier(),
    );

class AllProductsNotifier extends StateNotifier<List<Product>> {
  AllProductsNotifier() : super([]) {
    _fetchAll();
  }

  bool _isLoading = false;
  String? errorMessage;
  bool get isLoading => _isLoading;

  Future<void> _fetchAll() async {
    _isLoading = true;
    try {
      final products = await ApiService.fetchAllProducts();
      state = products;
      //print("Fetched ${products.length} products");
    } catch (e, st) {
      errorMessage = "Error fetching products: $e\n$st";
    } finally {
      _isLoading = false;
    }
  }
}

// Provider for selected category filtered products
final filteredProductsByCategoryProvider =
    Provider.family<List<Product>, String>((ref, categoryId) {
      final allProducts = ref.watch(allProductsProvider);
      return allProducts
          .where((product) => product.categoryId == categoryId)
          .toList();
    });

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

// For products by category
final productsByCategoryProvider = FutureProvider.family<List<Product>, String>(
  (ref, categoryId) async {
    return ApiService.fetchProductsByCategory(categoryId);
  },
);

// For searching products
final searchProductsProvider =
    FutureProvider.family<
      List<Product>,
      (String productName, String categoryId)
    >((ref, args) async {
      final (productName, categoryId) = args;
      return ApiService.fetchProducts(
        productName: productName,
        categoryId: categoryId,
      );
    });

// For placing order
final orderPlacementProvider =
    StateNotifierProvider<OrderPlacementNotifier, AsyncValue<void>>((ref) {
      return OrderPlacementNotifier();
    });

class OrderPlacementNotifier extends StateNotifier<AsyncValue<void>> {
  OrderPlacementNotifier() : super(const AsyncValue.data(null));

  Future<bool> placeOrder(Order order) async {
    state = const AsyncValue.loading();

    try {
      await ApiService.placeOrder(order);
      state = const AsyncValue.data(null);
      return true;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return false;
    }
  }
}

// For tracking order
final orderTrackingProvider =
    StateNotifierProvider<OrderTrackingNotifier, AsyncValue<List<Order>>>((
      ref,
    ) {
      return OrderTrackingNotifier();
    });

class OrderTrackingNotifier extends StateNotifier<AsyncValue<List<Order>>> {
  OrderTrackingNotifier() : super(const AsyncValue.data([]));

  Future<void> trackOrder(String phone) async {
    state = const AsyncValue.loading();

    try {
      final orders = await ApiService.trackOrder(phone);

      if (orders.isEmpty) {
        // Explicitly return empty list instead of throwing
        state = const AsyncValue.data([]);
      } else {
        state = AsyncValue.data(orders);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearTracking() {
    state = const AsyncValue.data([]);
  }
}

// To check whether the shipping is from or outside khulna
final shippingMethodProvider = StateProvider<String>((ref) => '');

// For setting the shipping cost value
final shippingCostProvider = StateProvider<double>((ref) => 0.0);

// // For categories
// final categoryProvider = FutureProvider<List<Category>>((ref) async {
//   return ApiService.fetchCategories();
// });
