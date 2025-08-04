import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:treatos_bd/models/category.dart';
import 'package:treatos_bd/models/product.dart';

class ApiService {
  static Future<List<Category>> fetchCategories() async {
    final res = await http.get(
      Uri.parse('https://pos.theabacuses.com/api/category'),
    );
    if (res.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(res.body);
      final List<dynamic> catdata = json['categories'];

      return catdata.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load Categories...');
    }
  }
}
