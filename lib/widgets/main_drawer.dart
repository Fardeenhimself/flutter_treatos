import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainDrawer extends StatefulWidget {
  const MainDrawer({super.key});

  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  bool isMenuSelected = true;

  // Menu Options
  List<Widget> _buildMenuOptions() {
    return [
      _buildDrawerItem(Icons.home, "Home", () {}),
      _buildDrawerItem(Icons.shopping_bag, "Products", () {}),
      _buildDrawerItem(Icons.local_shipping, "Track Order", () {}),
    ];
  }

  // Categories Options
  List<Widget> _buildCategoryOptions() {
    return [
      _buildDrawerItem(Icons.fastfood, "Cat Food", () {}),
      _buildDrawerItem(Icons.pets, "Accessories", () {}),
      _buildDrawerItem(Icons.local_hospital, "Healthcare", () {}),
    ];
  }

  // Drawer List Item
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(leading: Icon(icon), title: Text(title), onTap: onTap);
  }

  // Toggle Button Builder
  Widget _buildToggleButton(String text, bool isActive, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isActive ? Colors.purple : Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4),
            Container(
              height: 3,
              width: 200,
              decoration: BoxDecoration(
                color: isActive ? Colors.purple : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // --------------------------------------------- Drawer header---------------------------------
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.purple.shade100),
            child: Column(
              children: [
                Image.asset('assets/logo.png', height: 80),
                const SizedBox(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,

                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.facebook),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.instagram),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: FaIcon(FontAwesomeIcons.whatsapp),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ----------------------------------- Menu and category section ------------------------
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[200],
              ),
              child: Row(
                children: [
                  _buildToggleButton('Menu', isMenuSelected, () {
                    setState(() {
                      isMenuSelected = true;
                    });
                  }),
                  _buildToggleButton('Categories', !isMenuSelected, () {
                    setState(() {
                      isMenuSelected = false;
                    });
                  }),
                ],
              ),
            ),
          ),
          // Drawer content according to menu and categories
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: isMenuSelected
                  ? _buildMenuOptions()
                  : _buildCategoryOptions(),
            ),
          ),
        ],
      ),
    );
  }
}
