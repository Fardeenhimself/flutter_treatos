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
      appBar: AppBar(
        title: const Text(
          'SEARCH',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: MainDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
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
                data: (products) {
                  if (_searchController.text.trim().isEmpty) {
                    return Center(
                      child: Text(
                        'Items will appear here',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  } else if (products.isEmpty) {
                    return Center(
                      child: Text(
                        'No items found for your search',
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    );
                  }

                  // Matches found
                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return GestureDetector(
                        onTap: () {
                          PersistentNavBarNavigator.pushNewScreen(
                            context,
                            screen: ProductDetailScreen(productId: product.id),
                          );
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            child: Image.network(
                              product.productImage!,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stack) =>
                                  const Icon(
                                    Icons.image_not_supported,
                                    size: 30,
                                  ),
                            ),
                          ),
                          title: Text(product.productName),
                          subtitle: Text('৳${product.salePrice}'),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (err, _) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      'Something went wrong.\nCheck your Internet connection or try again later',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
