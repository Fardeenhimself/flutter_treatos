import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/screens/category_product_screen.dart';

class AllCategoiresScreen extends ConsumerWidget {
  const AllCategoiresScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text('ALL CATEGORIES')),
      body: categoriesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Text(
              'Something went wrong.\nCheck your Internet connection or try again later',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ),
        ),
        data: (categories) {
          if (categories.isEmpty) {
            return Center(child: Text('No Categories available'));
          }

          return ListView.separated(
            separatorBuilder: (context, index) =>
                const Divider(indent: 20, endIndent: 20),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 12,
                  right: 12,
                  bottom: 5,
                ),
                child: ListTile(
                  onTap: () {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: CategoryProductsScreen(
                        categoryName: category.categoryName,
                        categoryId: category.id,
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.primaryContainer,
                    radius: 30,
                    child: FadeInImage(
                      placeholder: AssetImage('assets/fallback.png'),
                      image: NetworkImage(category.imageUrl),
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(category.categoryName),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
