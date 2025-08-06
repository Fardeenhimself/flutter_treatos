import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/order.dart';
import 'package:treatos_bd/providers/api_provider.dart';
import 'package:treatos_bd/providers/cart_provider.dart';
import 'package:treatos_bd/screens/order_completion_screen.dart';
import 'package:treatos_bd/screens/cart_screen.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController nameController;
  late final TextEditingController addressController;
  late final TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final shippingCost = ref.watch(shippingCostProvider);
    const shippingMethod = 'Standard';

    double subtotal = 0;
    for (var item in cartItems) {
      final price = double.tryParse(item.salePrice) ?? 0.0;
      subtotal += price * item.quantity;
    }
    double total = subtotal + shippingCost;

    final List<OrderProduct> orderProducts = cartItems
        .map(
          (item) => OrderProduct(
            id: item.id,
            productName: item.productName,
            quantity: item.quantity,
            salePrice: double.parse(item.salePrice),
            totalPrice: double.parse(item.salePrice) * item.quantity,
          ),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...cartItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${item.productName.toUpperCase()} x${item.quantity}',
                          ),
                          Text(
                            '৳${(double.parse(item.salePrice) * item.quantity).toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal'),
                      Text('৳${subtotal.toStringAsFixed(2)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Shipping'),
                      Text('৳${shippingCost.toStringAsFixed(2)}'),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '৳${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Billing Form
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery To: ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    maxLength: 40,
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    maxLength: 11,
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty || value.trim().length < 11
                        ? 'Phone number is required and must be valid'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Billing Address',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    validator: (value) =>
                        value!.isEmpty ? 'Address is required' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Place Order Button
            ElevatedButton.icon(
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                'Place Order',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final order = Order(
                      phone: phoneController.text,
                      name: nameController.text,
                      address: addressController.text,
                      subtotal: subtotal,
                      shippingMethod: shippingMethod,
                      shippingCost: shippingCost,
                      total: total,
                      products: orderProducts,
                    );

                    final success = await ref
                        .read(orderPlacementProvider.notifier)
                        .placeOrder(order);

                    if (success && mounted) {
                      ref.read(cartProvider.notifier).clearCart();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (ctx) =>
                              const OrderStatusPage(isSuccess: true),
                        ),
                      );
                    } else if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Failed to place order. Please try again.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
