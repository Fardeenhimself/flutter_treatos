import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';
import 'package:treatos_bd/widgets/reset_wishlist_dialogue.dart';
import 'package:treatos_bd/widgets/wishlist_widget.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wishlistItems = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'WISH LIST',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            color: Colors.red,
            onPressed: () {
              if (wishlistItems.isEmpty) {
                return;
              }
              showEmptyWishlistConfirmationDialog(context, ref);
            },
            icon: CircleAvatar(
              radius: 25,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.delete, size: 30, color: Colors.red),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),

      body: wishlistItems.isEmpty
          ? Center(
              child: Text(
                'Your wishlist is empty',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
          : ListView.builder(
              itemCount: wishlistItems.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final item = wishlistItems[index];
                return WishlistCard(item: item, ref: ref);
              },
            ),
    );
  }
}
