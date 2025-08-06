import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/screens/product_details_screen.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchProductsPage extends ConsumerStatefulWidget {
  final String categoryId;
  const SearchProductsPage({super.key, required this.categoryId});

  @override
  ConsumerState<SearchProductsPage> createState() => _SearchProductsPageState();
}

class _SearchProductsPageState extends ConsumerState<SearchProductsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchText = _searchController.text.trim();
    final productsAsync = ref.watch(
      searchProductsProvider((searchText, widget.categoryId)),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Search Products')),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                ref.invalidate(searchProductsProvider);
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: productsAsync.when(
                data: (products) => products.isEmpty
                    ? const Center(child: Text('No products found.'))
                    : ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return GestureDetector(
                            onTap: () {
                              PersistentNavBarNavigator.pushNewScreen(
                                context,
                                screen: ProductDetailScreen(
                                  productId: product.id,
                                ),
                              );
                            },
                            child: ListTile(
                              leading: Image.network(
                                product.productImage,
                                width: 50,
                              ),
                              title: Text(product.productName),
                              subtitle: Text('৳${product.salePrice}'),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Center(child: Text('Error: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
