import 'package:flutter/material.dart';
import 'package:treatos_bd/widgets/bottom_nav_bar.dart';
import 'package:treatos_bd/widgets/carousel_bar.dart';
import 'package:treatos_bd/widgets/category_list.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/logo.png')),
      endDrawer: MainDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --------------------------------------------- Carousel Bar --------------------------------- \\
            CarouselBar(),
            const SizedBox(height: 20),

            // --------------------------------------------- Body Content --------------------------------- \\
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'Categories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            CategoryList(),
          ],
        ),
      ),

      // --------------------------------------------- Bottom Bar --------------------------------- \\
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
