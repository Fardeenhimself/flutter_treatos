class ApiRoutes {
  // base url
  static const baseUrl = 'https://pos.theabacuses.com/api';

  // Categories
  static const allCategoryApi = '$baseUrl/category';

  // Random Products
  static const randomProductsApi = '$allCategoryApi/random';

  // Random Category Product Detail
  static const randomCategoryProductApi = '$allCategoryApi/product/random';

  // All Product
  static const allProductsApi = '$baseUrl/product/all';

  // Random Products
  static const randomProducts = '$baseUrl/random-products';

  // Top Selling Products
  static const topSellingProductsApi = '$baseUrl/top-sale-products';

  // Product Detail
  static const productDetailApi = '$baseUrl/product/view';

  // List of product by category
  static const productByCategoryApi = '$allCategoryApi/product';

  // Search Product
  static const searchProductApi = '$baseUrl/search';

  // For placing order
  static const placeOrderApi = '$baseUrl/checkout';

  // Order Tracking Api
  static const trackOrderApi = '$baseUrl/track';
}
