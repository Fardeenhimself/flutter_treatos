import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/screens/checkout_screen.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';
import 'package:treatos_bd/widgets/reset_cart_dialogue.dart';
import 'package:treatos_bd/providers/api_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final shippingCost = ref.watch(shippingCostProvider);

    // Calculate subtotal
    double subtotal = 0;
    for (var item in cartItems) {
      subtotal += double.tryParse(item.salePrice)! * item.quantity;
    }

    double total = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CART',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.delete, size: 30, color: Colors.red),
            ),
            onPressed: () {
              if (cartItems.isEmpty) {
                return;
              }
              showEmptyCartConfirmationDialog(context, ref);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: cartItems.isEmpty
          ? Center(
              child: Text(
                'Cart is empty',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                item.productImage,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(
                                        Icons.image_not_supported,
                                      ),
                                    ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Info and controls
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurface,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '৳${item.salePrice} x ${item.quantity}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge!
                                        .copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.remove,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .updateQuantity(
                                                item.id,
                                                item.quantity - 1,
                                              );
                                        },
                                      ),
                                      Text(
                                        '${item.quantity}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        onPressed: () {
                                          ref
                                              .read(cartProvider.notifier)
                                              .updateQuantity(
                                                item.id,
                                                item.quantity + 1,
                                              );
                                        },
                                      ),
                                      const Spacer(),
                                      Text(
                                        '৳${(double.parse(item.salePrice) * item.quantity).toStringAsFixed(2)}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelLarge!
                                            .copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSurface,
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: CircleAvatar(
                                radius: 20,
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                child: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                              ),
                              onPressed: () {
                                ref
                                    .read(cartProvider.notifier)
                                    .removeFromCart(item.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Subtotal
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Subtotal:',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                          ),
                          Text(
                            '৳${subtotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Shipping label
                      Text(
                        'Shipping:',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                      ),

                      // Shipping options
                      Row(
                        children: [
                          Checkbox(
                            value: shippingCost == 40.0,
                            onChanged: (_) {
                              ref.read(shippingCostProvider.notifier).state =
                                  40.0;
                              ref.read(shippingMethodProvider.notifier).state =
                                  'Inside Khulna';
                            },
                          ),
                          Text(
                            'Inside Khulna (৳40.00)',
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: shippingCost == 120.0,
                            onChanged: (_) {
                              ref.read(shippingCostProvider.notifier).state =
                                  120.0;
                              ref.read(shippingMethodProvider.notifier).state =
                                  'Outside Khulna';
                            },
                          ),
                          Text(
                            'Outside Khulna (৳120.00)',
                            style: Theme.of(context).textTheme.labelLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Total
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            '৳${total.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge!
                                .copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Checkout Button
                Padding(
                  padding: const EdgeInsets.only(
                    top: 2,
                    left: 24,
                    right: 24,
                    bottom: 20,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: shippingCost == 0
                        ? () {
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 3),
                                content: Text(
                                  'Please select a shipping fee!',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            );
                          }
                        : () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: CheckoutPage(),
                            );
                          },
                    icon: Icon(
                      Icons.shopping_cart_checkout,
                      color: Theme.of(context).colorScheme.surface,
                      size: 25,
                    ),
                    label: Text(
                      'Check Out',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
