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
        title: "Home",
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon: Icon(Icons.home_outlined),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: "Search",
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
        inactiveIcon: Icon(Icons.search_outlined),
      ),
      PersistentBottomNavBarItem(
        title: "Wish List",
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
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
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '${wishlistItems.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        inactiveIcon: Icon(Icons.favorite_outline),
      ),
      PersistentBottomNavBarItem(
        title: "Cart",
        activeColorPrimary: Colors.deepPurple,
        inactiveColorPrimary: Colors.grey,
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
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$cartCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        inactiveIcon: Icon(Icons.shopping_cart_outlined),
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

    );
  }
}
