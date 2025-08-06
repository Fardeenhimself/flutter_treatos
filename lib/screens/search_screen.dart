import 'package:flutter/material.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset('assets/logo.png')),
      drawer: MainDrawer(),
      body: Center(child: Text('Search Screen')),
    );
  }
}
