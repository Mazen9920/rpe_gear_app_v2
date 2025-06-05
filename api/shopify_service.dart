import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ShopifyService {
  static Future<List<dynamic>> fetchProducts() async {
    try {
      final baseUrl = dotenv.env['SHOPIFY_BASE_URL'];
      final token = dotenv.env['SHOPIFY_ACCESS_TOKEN'];
      final apiVersion = dotenv.env['SHOPIFY_API_VERSION'] ?? '2024-04';

      if (baseUrl == null || token == null) {
        throw Exception('Missing Shopify credentials');
      }

      final url = Uri.parse('$baseUrl/admin/api/$apiVersion/products.json');
      final response = await http.get(
        url,
        headers: {
          'X-Shopify-Access-Token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return (data['products'] as List<dynamic>? ?? <dynamic>[]);
      } else {
        throw Exception('Shopify API error: ${response.statusCode}');
      }
    } catch (e) {
      return Future.error('Failed to fetch products: $e');
    }
  }
}
