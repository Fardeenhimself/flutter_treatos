import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //Image.asset(name),
            Icon(Icons.shopping_bag),
            const SizedBox(),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: 'TREATOS',
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(child: const SizedBox(width: 3)),
                  TextSpan(
                    text: 'BD',
                    style: TextStyle(color: Colors.purple),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
          IconButton(onPressed: () {}, icon: Icon(Icons.shopping_bag_outlined)),
        ],
      ),
      body: Center(child: Text('Welcome to treatos_bd')),
    );
  }
}
