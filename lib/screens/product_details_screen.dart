import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int quantity = 1;

  void _incrementQty() {
    setState(() {
      quantity++;
    });
  }

  void _decrementQty() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  // Invalidate the provider to refetch the data
  // Wait for refetch to complete before finishing refresh indicator
  Future<void> _refresh() async {
    ref.invalidate(productDetailProvider(widget.productId));
    await ref.read(productDetailProvider(widget.productId).future);
  }

  @override
  Widget build(BuildContext context) {
    final productDetailAsync = ref.watch(
      productDetailProvider(widget.productId),
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Product Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: productDetailAsync.when(
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
                    child: Image.network(
                      product.productImage,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image_not_supported,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Product Name
                Text(
                  product.productName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 12),

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
                    if (product.discountPrice != null)
                      Text(
                        '৳ ${product.salePrice}',
                        style: const TextStyle(
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 8),

                // Category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.categoryName != null)
                      Text(
                        'Category: ${product.categoryName}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    if (product.quantity == '0')
                      const Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          'Out of stock',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // Description
                const Text(
                  'This item is a customer favourite.',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),

                const SizedBox(height: 24),

                // // Quantity selector
                // Row(
                //   children: [
                //     const Text('Quantity:', style: TextStyle(fontSize: 16)),
                //     const SizedBox(width: 12),
                //     Container(
                //       decoration: BoxDecoration(
                //         color: Colors.white,
                //         border: Border.all(color: Colors.grey.shade300),
                //         borderRadius: BorderRadius.circular(8),
                //       ),
                //       child: Row(
                //         children: [
                //           IconButton(
                //             icon: const Icon(Icons.remove),
                //             onPressed: _decrementQty,
                //           ),
                //           Text(
                //             '$quantity',
                //             style: const TextStyle(fontSize: 16),
                //           ),
                //           IconButton(
                //             icon: const Icon(Icons.add),
                //             onPressed: _incrementQty,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 30),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart_outlined),
                        label: Text(
                          'Add to Cart',
                          style: const TextStyle(
                            fontSize: 16,
                            inherit: true,
                            color: Colors
                                .white, // 👈 fixes the interpolation crash
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.purpleAccent.shade200,
                        ),
                        onPressed: () {
                          if (product.quantity == '0') {
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
                                content: Text('Added $quantity to Cart'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent.shade200,
                        border: Border.all(color: Colors.purple),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.white,
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
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
