import 'dart:convert';
import 'package:http/http.dart' as http;
import 'produk_model.dart';

class ApiService {
  static const String baseUrl = "https://task.itprojects.web.id";
  static String? token;

  Future<bool> login(String username, String password) async {
    final url = Uri.parse("$baseUrl/api/auth/login");
    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          token = data['data']['token'];
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  Future<List<Product>> getProducts() async {
    final url = Uri.parse("$baseUrl/api/products");

    try {
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          List<dynamic> jsonList = data['data']['products'];
          List<Product> products = jsonList
              .map((json) => Product.fromJson(json))
              .toList();

          return products;
        }
      }
      return [];
    } catch (e) {
      print("Get Products Error: $e");
      return [];
    }
  }

  Future<bool> addProduct(String name, int price, String description) async {
    final url = Uri.parse("$baseUrl/api/products");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "price": price,
          "description": description,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Add Product Error: $e");
      return false;
    }
  }

  Future<bool> deleteProduct(int productId) async {
    final url = Uri.parse("$baseUrl/api/products/$productId");

    try {
      final response = await http.delete(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  void logout() {
    token = null;
  }

Future<bool> submitTugas(String name, int price, String description, String githubUrl) async {
    final url = Uri.parse("$baseUrl/api/products/submit");

    try {
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "name": name,
          "price": price,
          "description": description,
          "github_url": githubUrl,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      return false;
    } catch (e) {
      print("Submit Tugas Error: $e");
      return false;
    }
  }

}