import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/models/cart_item.dart';
import 'package:treatos_bd/widgets/cart_widget.dart';
import 'package:treatos_bd/widgets/reset_cart_dialogue.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Your Cart',
          style: TextStyle(
            letterSpacing: 1,
            decoration: TextDecoration.underline,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.red,
            onPressed: () {
              if (cartItems.isEmpty) {
                return;
              }
              showEmptyCartConfirmationDialog(context, ref);
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartCard(item: item, ref: ref);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      ref.read(cartProvider.notifier).clearCart();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Checkout complete!')),
                      );
                    },
                    label: const Text(
                      'Check Out',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: const Icon(Icons.shopping_cart_checkout, size: 25),
                  ),
                ),
              ],
            ),
    );
  }
}
