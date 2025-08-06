import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:treatos_bd/screens/product_details_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ProductGridTile extends ConsumerWidget {
  final Product product;
  final String image;

  const ProductGridTile({
    super.key,
    required this.product,
    required this.image,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlist = ref.watch(wishlistProvider);
    final isInWishlist = wishlist.any((item) => item.id == product.id);

    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: ProductDetailScreen(productId: product.id),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
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
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: image.isNotEmpty
                    ? Image.network(
                        image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/fallback.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          );
                        },
                      )
                    : Image.asset(
                        'assets/fallback.png',
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
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
                    style: const TextStyle(color: Colors.purple, fontSize: 14),
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
                          final isInWishlist = wishlistNotifier.isInWishlist(
                            product.id,
                          );

                          ScaffoldMessenger.of(context).clearSnackBars();

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
                          if (product.quantity == '0.00') {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text(
                                  'Product not currently available',
                                ),
                              ),
                            );
                          } else {
                            ref.read(cartProvider.notifier).addToCart(product);
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added ${product.productName} to Cart',
                                ),
                              ),
                            );
                          }
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
      ),
    );
  }
}
