import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
class ApiService {
  static const String baseUrl = "https://fakestoreapi.com/products";

  Future<List<Product>> fetchProducts({int page = 1, int limit = 10}) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      List<Product> allProducts =
          jsonData.map((json) => Product.fromJson(json)).toList();

     
      int startIndex = (page - 1) * limit;
      int endIndex = startIndex + limit;
      return allProducts.sublist(
          startIndex, endIndex.clamp(0, allProducts.length));
    } else {
      throw Exception("Failed to load products");
    }
  }
}

