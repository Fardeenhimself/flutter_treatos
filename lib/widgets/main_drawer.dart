import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/providers/theme_provider.dart';
import 'package:treatos_bd/screens/all_categoires_screen.dart';
import 'package:treatos_bd/screens/all_products_screen.dart';
import 'package:treatos_bd/screens/category_product_screen.dart';
import 'package:treatos_bd/screens/tracking_order.dart';
import 'package:url_launcher/url_launcher.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Column(
              children: [
                Image.asset('assets/applogo.png', height: 70),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'TREATOS',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'BD',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.purpleAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          final Uri facebookUrl = Uri.parse(
                            'https://www.facebook.com/treatos.bd/',
                          );

                          try {
                            await launchUrl(
                              facebookUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not open Facebook'),
                              ),
                            );
                          }
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.facebook,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          final Uri whatsappUrl = Uri.parse(
                            'https://wa.me/8801324741192',
                          );

                          if (await canLaunchUrl(whatsappUrl)) {
                            await launchUrl(
                              whatsappUrl,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Could not open WhatsApp'),
                              ),
                            );
                          }
                        },
                        icon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 5),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.nights_stay),
                  title: Text('D A R K  M O D E'),
                  trailing: Consumer(
                    builder: (context, ref, _) {
                      final isDark = ref.watch(themeProvider) == ThemeMode.dark;

                      return CupertinoSwitch(
                        value: isDark,
                        onChanged: (value) {
                          ref.read(themeProvider.notifier).toggleTheme(value);
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                ListTile(
                  onTap: () => Navigator.of(context).pop(),
                  leading: Icon(Icons.home_filled),
                  title: Text('H O M E'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AllProductsScreen(),
                    );
                  },
                  leading: Icon(Icons.list_alt_rounded),
                  title: Text('P R O D U C T S'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: TrackOrderScreen(),
                    );
                  },
                  leading: Icon(Icons.local_shipping_rounded),
                  title: Text('T R A C K  O R D E R'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AllCategoiresScreen(),
                    );
                  },
                  leading: Icon(Icons.category_rounded),
                  title: Text('C A T E G O R I E S'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
