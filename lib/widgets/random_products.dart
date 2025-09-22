import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:treatos_bd/screens/product_details_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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
                PersistentNavBarNavigator.pushNewScreen(
                  context,
                  screen: ProductDetailScreen(productId: product.id),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withAlpha(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/fallback.png',
                                  image: imageUrl!,
                                  fit: BoxFit.contain,
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/fallback.png',
                                          fit: BoxFit.contain,
                                        );
                                      },
                                ),
                              ),
                            ),
                            // NEW Banner
                            Positioned(
                              top: 3,
                              right: 2,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'NEW',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.productName.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.discountPrice == null
                            ? '৳ ${product.salePrice}'
                            : '৳ ${product.discountPrice}',
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

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

                              ScaffoldMessenger.of(context).clearSnackBars();

                              if (isInWishlist) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.productName} is already in your wishlist.',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                          ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              } else {
                                wishlistNotifier.addToWishlist(product);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.productName} added to wishlist!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                          ),
                                    ),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                            icon: Icon(
                              isInWishlist
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                            ),
                            iconSize: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            tooltip: 'Add to cart',
                            onPressed: () {
                              ref
                                  .read(cartProvider.notifier)
                                  .addToCart(product);
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.productName} added to cart!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.surface,
                                        ),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            },
                            icon: Icon(Icons.shopping_cart_outlined),
                            iconSize: 30,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      error: (err, stack) => Padding(
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
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
