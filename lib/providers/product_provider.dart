import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

// Clase para la gestión de los productos a través de la base de datos
class ProductService {
  final String _baseUrl = 'https://pf5-autenticador-default-rtdb.europe-west1.firebasedatabase.app';

  // Función para cargar los productos
  Future<List<Product>> loadProducts() async {
    final url = Uri.parse('$_baseUrl/products.json');
    final response = await http.get(url);

    if (response.statusCode != 200) return [];

    final Map<String, dynamic>? data = json.decode(response.body);
    if (data == null) return [];

    return data.entries.map((e) {
      final product = Product.fromJson(e.value);
      product.id = e.key;
      return product;
    }).toList();
  }

  // Función para guardar un producto en la base de datos
  Future<void> saveProduct(Product product) async {
    final url = product.id == null
        ? Uri.parse('$_baseUrl/products.json')
        : Uri.parse('$_baseUrl/products/${product.id}.json');

    final body = json.encode(product.toJson());

    if (product.id == null) {
      await http.post(url, body: body);
    } else {
      await http.put(url, body: body);
    }
  }

  // Función para eliminar un producto de la base de datos
  Future<void> deleteProduct(String productId) async {
    final url = Uri.parse('$_baseUrl/products/$productId.json');

    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al borrar el producto');
    }
  }
}
