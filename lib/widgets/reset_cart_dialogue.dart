import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/cart_provider.dart';

Future<void> showEmptyCartConfirmationDialog(
  BuildContext context,
  WidgetRef ref,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Empty Cart'),
        content: const Text('Are you sure you want to empty your cart?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(cartProvider.notifier).clearCart();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Removed successfully')),
              );
            },
            child: const Text('Empty Cart'),
          ),
        ],
      );
    },
  );
}
