import 'package:flutter/material.dart';
import 'package:treatos_bd/screens/all_products_screen.dart';
import 'package:treatos_bd/widgets/brand_carousel.dart';
import 'package:treatos_bd/widgets/carousel_bar.dart';
import 'package:treatos_bd/widgets/category_list.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';
import 'package:treatos_bd/widgets/random_products.dart';
import 'package:treatos_bd/widgets/top_sale_products.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('TREATOS'),
            const SizedBox(width: 5),
            Text('BD', style: TextStyle(color: Colors.purpleAccent)),
          ],
        ),
      ),
      drawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ----  CAROUSEL ---
            CarouselBar(),
            const SizedBox(height: 20),

            // ----  CATEGORIES  ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Categories',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(indent: 30, endIndent: 30, thickness: 2),
            const SizedBox(height: 10),
            CategoryList(),
            const SizedBox(height: 20),

            // ----  POPULAR PRODUCTS  ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Top Selling Products',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(indent: 30, endIndent: 30, thickness: 2),
            const SizedBox(height: 10),
            TopSaleProducts(),
            const SizedBox(height: 20),

            // ----  BRAND CAROUSEL ---
            BrandCarousel(),
            const SizedBox(height: 20),

            // ----  RANDOM PRODUCTS ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Recommendations For You',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(indent: 30, endIndent: 30, thickness: 2),
            const SizedBox(height: 10),
            RandomProducts(),

            // ----  View All Products ---
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: TextButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AllProductsScreen(),
                      withNavBar: true,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View All Products',
                        style: Theme.of(context).textTheme.titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 25,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
