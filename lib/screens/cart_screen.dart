import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/cart_item.dart';
import 'package:treatos_bd/providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Your Cart')),
      body: cartItems.isEmpty
          ? Center(child: Text('Cart is empty'))
          : ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return ListTile(
                  leading: Image.network(
                    item.productImage,
                    width: 40,
                    height: 40,
                  ),
                  title: Text(item.productName),
                  subtitle: Text('৳${item.salePrice} x ${item.quantity}'),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      ref.read(cartProvider.notifier).removeFromCart(item.id);
                    },
                  ),
                );
              },
            ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                onPressed: () {
                  ref.read(cartProvider.notifier).clearCart();
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Checkout complete!')));
                },
                child: Text('Checkout'),
              ),
            ),
    );
  }
}
