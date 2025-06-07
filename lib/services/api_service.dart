import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';

class ApiService {
  static const baseUrl = 'https://eemi-39b84a24258a.herokuapp.com';

  // FIXME Essaye de garder de la coherence dans tes methodes. Des fois, tu mets des headers, des fois non.

  Future<List<Product>> fetchProducts({String query = ''}) async {
    final uri = Uri.parse('$baseUrl/products${query.isNotEmpty ? '?search=$query' : ''}');
    final res = await http.get(uri);
    if (res.statusCode == 200) {
      return Product.listFromJson(res.body);
    } else {
      throw Exception('Erreur chargement');
    }
  }

  Future<Product> createProduct(Product p) async {
    final res = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 201) {
      return Product.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur création');
    }
  }

  Future<Product> updateProduct(Product p) async {
    final res = await http.put(
      Uri.parse('$baseUrl/products/${p.uuid}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(p.toJson()),
    );
    if (res.statusCode == 200) {
      return Product.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Erreur mise à jour');
    }
  }

  Future<void> deleteProduct(String uuid) async {
    final res = await http.delete(Uri.parse('$baseUrl/products/$uuid'));
    if (res.statusCode != 204) {
      throw Exception('Erreur suppression');
    }
  }
}
