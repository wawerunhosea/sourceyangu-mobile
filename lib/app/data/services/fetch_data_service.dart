import 'package:sourceyangu/app/data/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  Future<List<Product>> getFeaturedProducts() async {
    final response = await http.get(
      Uri.parse('https://yourapi.com/products/featured'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Product.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load featured products');
    }
  }

  Future<List<String>> getCategories() async {
    final response = await http.get(
      Uri.parse('https://yourapi.com/categories'),
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data
          .map((item) => item.toString())
          .toList(); // Or use Category.fromJson if it's a model
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
