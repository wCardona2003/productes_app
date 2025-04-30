import 'package:flutter/material.dart';
import 'package:productes_app/widgets/product_card.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

// Pantalla de inicio con productos
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();

  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _productService.loadProducts();
  }

  // Función para recargar la página de productos
  Future<void> _refreshProducts() async {
    setState(() {
      _futureProducts = _productService.loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Productos')),
      body: FutureBuilder<List<Product>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data ?? [];

          // Si no hay productos se muestra el mensaje "No hay productos"
          if (products.isEmpty) {
            return Center(child: Text('No hay productos'));
          }

          return RefreshIndicator(
            onRefresh: _refreshProducts,
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                    child: ProductCard(product: product),
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        'product_screen',
                        arguments: product,
                      );

                      if (result == true) {
                        await _refreshProducts();
                      }
                    }
                );
              },
            ),
          );
        },
      ),
      // Botón para añadir productos
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.pushNamed(context, 'add_product');
          if (result == true) {
            _refreshProducts();
          }
        },
      ),
    );
  }
}
