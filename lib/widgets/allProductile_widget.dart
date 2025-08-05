import 'package:flutter/material.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';

class ProductGridTile extends StatelessWidget {
  final Product product;
  final String image;
  final WidgetRef ref;

  const ProductGridTile({
    super.key,
    required this.product,
    required this.image,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: image.isNotEmpty
                  ? Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Image.asset('assets/fallback.png', fit: BoxFit.cover),
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
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  '৳${product.salePrice}',
                  style: const TextStyle(color: Colors.purple),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Add to wishlist',
                      icon: const Icon(Icons.favorite_outline),
                      onPressed: () {
                        final wishlist = ref.read(wishlistProvider.notifier);
                        final isInWishlist = wishlist.isInWishlist(product.id);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        if (isInWishlist) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.productName} is already in wishlist',
                              ),
                            ),
                          );
                        } else {
                          wishlist.addToWishlist(product);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${product.productName} added to wishlist',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    IconButton(
                      tooltip: 'Add to cart',
                      icon: const Icon(Icons.shopping_cart_outlined),
                      onPressed: () {
                        ref.read(cartProvider.notifier).addToCart(product);
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${product.productName} added to cart',
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
