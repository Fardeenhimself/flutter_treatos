import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/screens/product_details_screen.dart';
import 'package:treatos_bd/widgets/allProductile_widget.dart';

class CategoryProductsScreen extends ConsumerWidget {
  final String categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(
      productsByCategoryProvider(categoryId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(categoryName)),
      body: filteredProductsAsync.when(
        data: (filteredProducts) {
          if (filteredProducts.isEmpty) {
            return const Center(
              child: Text('No products available in this category.'),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: filteredProducts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = filteredProducts[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(productId: product.id),
                    ),
                  );
                },
                child: ProductGridTile(
                  product: product,
                  image: product.productImage,
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
