import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/providers/wishlist_provider.dart';
import 'package:treatos_bd/screens/cart_screen.dart';
import 'package:treatos_bd/screens/home_screen.dart';
import 'package:treatos_bd/screens/search_screen.dart';
import 'package:treatos_bd/screens/wishlist_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MainTab extends ConsumerStatefulWidget {
  const MainTab({super.key});

  @override
  ConsumerState<MainTab> createState() => _MainTabState();
}

class _MainTabState extends ConsumerState<MainTab> {
  // Persistent tab controller
  final _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _screens() {
    // List of screens to be displayed
    return [
      HomeScreen(),
      SearchProductsPage(categoryId: ''),
      WishlistScreen(),
      CartScreen(),
    ];
  }

  // List of nav bar items
  List<PersistentBottomNavBarItem> _navBarItems() {
    // To show the count of cart items
    final cartItems = ref.watch(cartProvider);
    final cartCount = cartItems.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    // To show the count of wish list
    final wishlistItems = ref.watch(wishlistProvider);
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        inactiveIcon: Icon(Icons.home_outlined),
        iconSize: 25,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        activeColorSecondary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        inactiveIcon: Icon(Icons.search_outlined),
        iconSize: 25,
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        activeColorSecondary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        activeColorSecondary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.favorite),
            if (wishlistItems.isNotEmpty)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${wishlistItems.length}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        inactiveIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.favorite_border_outlined),
            if (wishlistItems.isNotEmpty)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${wishlistItems.length}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        iconSize: 25,
      ),
      PersistentBottomNavBarItem(
        activeColorPrimary: Theme.of(context).colorScheme.tertiary,
        activeColorSecondary: Theme.of(context).colorScheme.primary,
        inactiveColorPrimary: Theme.of(context).colorScheme.secondary,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart),
            if (cartCount > 0)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$cartCount',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        inactiveIcon: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_outlined),
            if (cartCount > 0)
              Positioned(
                top: -4,
                right: -6,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$cartCount',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        iconSize: 25,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _screens(),
      items: _navBarItems(),
      controller: _controller,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
