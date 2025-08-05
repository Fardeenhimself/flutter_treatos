import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';

Future<void> showEmptyWishlistConfirmationDialog(
  BuildContext context,
  WidgetRef ref,
) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Empty Wishlist'),
        content: const Text(
          'Are you sure you want to remove all items from wish list?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              ref.read(wishlistProvider.notifier).clearWishlist();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Removed successfully')),
              );
            },
            child: const Text('Empty Wishlist'),
          ),
        ],
      );
    },
  );
}
