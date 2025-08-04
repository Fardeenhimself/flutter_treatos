import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';

class RandomProducts extends ConsumerWidget {
  const RandomProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final randomProductsAsync = ref.watch(randomProductsProvider);

    return randomProductsAsync.when(
      data: (randomProducts) => Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: randomProducts.length,
          itemBuilder: (ctx, index) {
            final product = randomProducts[index];
            final imageUrl = product.productImage;

            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/fallback.png', // Replace with your fallback image
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    );
                                  },
                                )
                              : Image.asset(
                                  'assets/fallback.png', // Fallback if image is empty
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                        ),

                        // NEW Banner
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'NEW',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(
                          product.productName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '৳${product.salePrice}',
                          style: const TextStyle(
                            color: Colors.purple,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Add to wishlist',
                              onPressed: () {
                                // Add to wishlist
                              },
                              icon: const Icon(Icons.favorite_outline),
                              iconSize: 20,
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              tooltip: 'Add to cart',
                              onPressed: () {
                                // Add to cart
                              },
                              icon: const Icon(Icons.shopping_cart_outlined),
                              iconSize: 20,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
