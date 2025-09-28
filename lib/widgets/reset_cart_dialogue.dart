import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/cart_provider.dart';

void showEmptyCartConfirmationDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Empty Cart?'),
      content: const Text(
        'Are you sure you want to remove all items from the cart?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          child: const Text('Clear Cart'),
          onPressed: () {
            ref.read(cartProvider.notifier).clearCart();
            Navigator.of(ctx).pop();

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Removed Successfully!')),
            );
          },
        ),
      ],
    ),
  );
}
