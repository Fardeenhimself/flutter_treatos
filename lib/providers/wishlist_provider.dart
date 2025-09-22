import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:treatos_bd/models/wishlist_item.dart';
import 'package:treatos_bd/models/product.dart';

class WishlistNotifier extends StateNotifier<List<WishlistItem>> {
  WishlistNotifier() : super([]) {
    _dbReady = _initDb();
  }

  late Database _db;
  late Future<void> _dbReady;

  Future<void> _initDb() async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = p.join(dir.path, 'wishlist.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE wishlist (
            id TEXT PRIMARY KEY,
            productName TEXT,
            productImage TEXT,
            salePrice TEXT
          )
        ''');
      },
    );

    await _loadWishlist();
  }

  Future<void> _loadWishlist() async {
    final List<Map<String, dynamic>> maps = await _db.query('wishlist');
    state = maps.map((map) => WishlistItem.fromMap(map)).toList();
  }

  Future<void> addToWishlist(Product product) async {
    await _dbReady;

    final exists = state.any((wish) => wish.id == product.id);
    if (!exists) {
      final item = WishlistItem(
        id: product.id,
        productName: product.productName,
        productImage: product.productImage!,
        salePrice: product.salePrice,
      );
      await _db.insert('wishlist', item.toMap());
      await _loadWishlist();
    }
  }

  Future<void> removeFromWishlist(String id) async {
    await _dbReady;
    await _db.delete('wishlist', where: 'id = ?', whereArgs: [id]);
    await _loadWishlist();
  }

  Future<void> clearWishlist() async {
    await _dbReady;
    await _db.delete('wishlist');
    state = [];
  }

  bool isInWishlist(String id) {
    return state.any((item) => item.id == id);
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, List<WishlistItem>>((ref) {
      return WishlistNotifier();
    });
