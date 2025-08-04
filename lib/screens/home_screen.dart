import 'package:flutter/material.dart';
import 'package:treatos_bd/widgets/brand_carousel.dart';
import 'package:treatos_bd/widgets/carousel_bar.dart';
import 'package:treatos_bd/widgets/category_list.dart';

import 'package:treatos_bd/widgets/random_products.dart';
import 'package:treatos_bd/widgets/top_sale_products.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------------------------------------------|| Body Content ||--------------------------------- \\

            // ----  CAROUSEL ---
            CarouselBar(),
            const SizedBox(height: 20),

            // ----  CATEGORIES  ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            CategoryList(),
            const SizedBox(height: 20),

            // ----  POPULAR PRODUCTS  ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Top Selling Products',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
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
                    // Navigate to all products
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View All Products',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.arrow_right_alt, size: 25),
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
