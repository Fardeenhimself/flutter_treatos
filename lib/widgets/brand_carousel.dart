import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class BrandCarousel extends StatelessWidget {
  BrandCarousel({super.key});
  // List of images for carousel
  final List<String> brandImage = [
    'assets/1.png',
    'assets/2.png',
    'assets/3.png',
    'assets/4.png',
    'assets/5.png',
    'assets/6.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: CarouselSlider(
        items: brandImage.map((imagePath) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.all(8),
              child: Image.asset(imagePath, fit: BoxFit.contain, height: 60),
            ),
          );
        }).toList(),
        options: CarouselOptions(
          height: 100,
          enlargeCenterPage: true,
          viewportFraction: 0.3,
        ),
      ),
    );
  }
}
