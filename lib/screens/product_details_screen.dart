import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:treatos_bd/screens/all_products_screen.dart';
import 'package:treatos_bd/screens/popular_products.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  Future<void> _refresh() async {
    ref.invalidate(productDetailProvider(widget.productId));
    await ref.read(productDetailProvider(widget.productId).future);
  }

  // Sending message to whatsapp using url_launcher
  Future<void> sendMessageToWhatsApp({
    required String phoneNumber,
    required String productName,
  }) async {
    final message = Uri.encodeComponent(
      "Hello, I'm interested in the product: $productName. Could you provide more details?",
    );
    final whatsappUrl = Uri.parse("https://wa.me/$phoneNumber?text=$message");

    if (!await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    final productDetailAsync = ref.watch(
      productDetailProvider(widget.productId),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('PRODUCT DETAILS')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            productDetailAsync.when(
              data: (product) => RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Product Image
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/fallback.png',
                            image: product.productImage!,
                            fit: BoxFit.contain,
                            height: 250,
                            imageErrorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/fallback.png',
                                fit: BoxFit.contain,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Product Name
                      Text(
                        product.productName.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Prices (if no discount price show sale price)
                      Row(
                        children: [
                          Text(
                            product.discountPrice == null
                                ? '৳${product.salePrice}'
                                : '৳${product.discountPrice}',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            product.discountPrice == null
                                ? ''
                                : '৳${product.salePrice}',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.red,
                              decorationThickness: 2,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Category
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (product.categoryName != null)
                            Text(
                              'Category: ${product.categoryName}',
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                  ),
                            ),
                          const SizedBox(height: 10),
                          product.quantity == '0.00'
                              ? Text(
                                  'Out of stock',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              : Text(
                                  'In Stock',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Description
                      Text(
                        'This item is a customer favourite.',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                      ),

                      const SizedBox(height: 30),
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: Icon(
                                Icons.shopping_cart,
                                color: Theme.of(context).colorScheme.surface,
                                size: 25,
                              ),
                              label: Text(
                                'Add to Cart',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.surface,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
                              ),
                              onPressed: () {
                                if (product.quantity == '0.00') {
                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: Duration(seconds: 5),
                                      content: Text(
                                        'Product not currently available',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                            ),
                                      ),
                                    ),
                                  );
                                } else {
                                  ref
                                      .read(cartProvider.notifier)
                                      .addToCart(product);
                                  ScaffoldMessenger.of(
                                    context,
                                  ).clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Added ${product.productName} to Cart',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.surface,
                                            ),
                                      ),
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.favorite,
                                color: Theme.of(context).colorScheme.surface,
                                size: 25,
                              ),
                              onPressed: () {
                                ref
                                    .read(wishlistProvider.notifier)
                                    .addToWishlist(product);
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added ${product.productName} to Wishlist',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.surface,
                                          ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Products',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => AllProductsScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'See More',
                              style: Theme.of(context).textTheme.labelMedium!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      PopularProducts(),
                    ],
                  ),
                ),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Text(
                  'Something went wrong. Check your Internet connection or try again later',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: productDetailAsync.when(
        data: (product) => FloatingActionButton(
          onPressed: () {
            sendMessageToWhatsApp(
              phoneNumber: '8801324741192',
              productName: product.productName,
            );
          },
          backgroundColor: Colors.green,
          child: const FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
        ),
        loading: () => const SizedBox.shrink(),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}
