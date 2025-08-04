import 'package:flutter/material.dart';
import 'package:treatos_bd/widgets/bottom_nav_bar.dart';
import 'package:treatos_bd/widgets/carousel_bar.dart';
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
            Center(
              child: Text(
                'Welcome to treatos_bd',
                style: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),

      // --------------------------------------------- Bottom Bar --------------------------------- \\
      bottomNavigationBar: BottomNavBar(),
    );
  }
}
