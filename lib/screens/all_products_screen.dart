import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/widgets/allProductile_widget.dart';

class AllProductsScreen extends ConsumerStatefulWidget {
  const AllProductsScreen({super.key});

  @override
  ConsumerState<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends ConsumerState<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final products = ref.watch(allProductsProvider);
    final notifier = ref.read(allProductsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('ALL PRODUCTS')),
      body: notifier.isLoading
          // Show loader while fetching
          ? const Center(child: CircularProgressIndicator())
          // else show products
          : notifier.errorMessage != null
          ? Padding(
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
            )
          : products.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
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
                  image: product.productImage!,
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  'No produts available',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ),
            ),
    );
  }
}
