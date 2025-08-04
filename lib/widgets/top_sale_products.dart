import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';

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
                          style: TextStyle(color: Colors.red),
                        ),
                        if (product.totalSold != null)
                          Text(
                            'Sold: ${product.totalSold} items',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),

                        // Icon guttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              tooltip: 'Add to wishlist',
                              onPressed: () {
                                // Add to wishlist
                              },
                              icon: Icon(Icons.favorite_outline),
                              iconSize: 20,
                            ),
                            IconButton(
                              tooltip: 'Add to cart',
                              onPressed: () {
                                // Add to cart
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
