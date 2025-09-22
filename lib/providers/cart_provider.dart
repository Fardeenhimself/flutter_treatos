import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:treatos_bd/models/cart_item.dart';
import 'package:treatos_bd/models/product.dart';

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]) {
    _dbReady = _initDb();
  }

  late Database _db;
  late Future<void> _dbReady;

  Future<void> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = p.join(dir.path, 'cart.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE cart (
            id TEXT PRIMARY KEY,
            productName TEXT,
            salePrice TEXT,
            productImage TEXT,
            quantity INTEGER
          )
        ''');
      },
    );

    await _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    final List<Map<String, dynamic>> maps = await _db.query('cart');
    state = maps.map((map) => CartItem.fromMap(map)).toList();
  }

  Future<void> addToCart(Product product) async {
    await _dbReady;

    final index = state.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      // Increase quantity if product already in cart
      final updatedItem = state[index];
      updatedItem.quantity++;
      await _db.update(
        'cart',
        updatedItem.toMap(),
        where: 'id = ?',
        whereArgs: [updatedItem.id],
      );
    } else {
      // Insert new product to cart
      final newItem = CartItem(
        id: product.id,
        productName: product.productName,
        salePrice: product.salePrice,
        productImage: product.productImage!,
        quantity: 1,
      );
      await _db.insert('cart', newItem.toMap());
    }

    await _loadCartItems();
  }

  Future<void> removeFromCart(String productId) async {
    await _dbReady;
    await _db.delete('cart', where: 'id = ?', whereArgs: [productId]);
    await _loadCartItems();
  }

  Future<void> clearCart() async {
    await _dbReady;
    await _db.delete('cart');
    state = [];
  }

  Future<void> updateQuantity(String id, int quantity) async {
    await _dbReady;
    if (quantity <= 0) {
      // Remove item if quantity 0 or less
      await removeFromCart(id);
      return;
    }
    await _db.update(
      'cart',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
    await _loadCartItems();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});
