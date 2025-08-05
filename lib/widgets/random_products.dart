import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:treatos_bd/screens/product_details_screen.dart';

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
            final wishlist = ref.watch(wishlistProvider);
            final isInWishlist = wishlist.any((item) => item.id == product.id);

            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) =>
                        ProductDetailScreen(productId: product.id),
                  ),
                );
              },
              child: Container(
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
                                    product.productImage,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.image_not_supported,
                                        size: 100,
                                        color: Colors.grey,
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
                                  final wishlistNotifier = ref.read(
                                    wishlistProvider.notifier,
                                  );
                                  final isInWishlist = wishlistNotifier
                                      .isInWishlist(product.id);

                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();

                                  if (isInWishlist) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.productName} is already in your wishlist.',
                                        ),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  } else {
                                    wishlistNotifier.addToWishlist(product);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${product.productName} added to wishlist!',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  isInWishlist
                                      ? Icons.favorite
                                      : Icons.favorite_border_outlined,
                                ),
                                iconSize: 20,
                              ),
                              const SizedBox(width: 10),
                              IconButton(
                                tooltip: 'Add to cart',
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addToCart(product);
                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '${product.productName} added to cart!',
                                      ),
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                                },
                                icon: Icon(Icons.shopping_cart_outlined),
                                iconSize: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
