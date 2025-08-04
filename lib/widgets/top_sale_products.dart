import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';

class TopSaleProducts extends ConsumerWidget {
  const TopSaleProducts({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topSaleProductsAsync = ref.watch(topSaleProductsProvider);

    return topSaleProductsAsync.when(
      data: (topProducts) => Padding(
        padding: EdgeInsets.all(12),
        child: GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.75,
          ),
          itemCount: topProducts.length,
          itemBuilder: (ctx, index) {
            final product = topProducts[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        product.productImage,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsGeometry.all(8),
                    child: Column(
                      children: [
                        Text(
                          product.productName.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '৳${product.salePrice}',
                          style: TextStyle(color: Colors.purple),
                        ),
                        if (product.totalSold != null)
                          Text(
                            'Sold: ${product.totalSold} items',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),

                        // Icon buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Add to wishlist',
                              onPressed: () {
                                ref
                                    .read(wishlistProvider.notifier)
                                    .addToWishlist(product);
                                ScaffoldMessenger.of(context).clearSnackBars();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${product.productName} added to wish list!',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: Icon(Icons.favorite_outline),
                              iconSize: 20,
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
            );
          },
        ),
      ),
      error: (err, stack) => Center(child: Text('Error: $err')),
      loading: () => Center(child: CircularProgressIndicator()),
    );
  }
}
