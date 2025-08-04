import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/product.dart';
import 'package:treatos_bd/services/api_service.dart';

final categoryProvider = FutureProvider<List<Category>>((ref) async {
  return ApiService.fetchCategories();
});
