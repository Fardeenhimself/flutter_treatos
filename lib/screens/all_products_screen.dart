import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/widgets/allProductile_widget.dart';
import 'package:treatos_bd/widgets/main_drawer.dart';

class AllProductsScreen extends ConsumerStatefulWidget {
  const AllProductsScreen({super.key});

  @override
  ConsumerState<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 300) {
        ref.read(allProductsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);
    final notifier = ref.read(allProductsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('All Products')),
      endDrawer: MainDrawer(),
      body: products.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: products.length + (notifier.hasMore ? 1 : 0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                if (index == products.length) {
                  return const Center(child: CircularProgressIndicator());
                }

                final product = products[index];
                return ProductGridTile(
                  product: product,
                  image: product.productImage,
                );
              },
            ),
    );
  }
}
