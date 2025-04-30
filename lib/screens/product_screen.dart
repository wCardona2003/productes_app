import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';
import '../screens/edit_product.dart';

class ProductScreen extends StatefulWidget {
  final Product product;

  const ProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Product _product;
  final ProductService _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  // Función para reservar producto
  Future<void> _reservarProducto() async {
    setState(() {
      _product.available = false;
    });

    await _productService.saveProduct(_product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto reservado con éxito')),
    );

    Navigator.pop(context, true);
  }

  // Función para eliminar producto
  Future<void> _deleteProduct() async {
    try {
      await _productService.deleteProduct(_product.id!);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto eliminado con éxito')),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el producto')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_product.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _product.imageUrl != null
                  ? Image.network(_product.imageUrl!)
                  : Icon(Icons.image, size: 100),
              SizedBox(height: 20),
              Text(
                _product.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Precio: €${_product.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                _product.description ?? 'No disponible',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              Text(
                _product.available ? 'Disponible' : 'Reservado',
                style: TextStyle(
                  fontSize: 18,
                  color: _product.available ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 20),
              if (_product.available)
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _reservarProducto,
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontSize: 18),
                    ),
                    child: Text('Reservar'),
                  ),
                )
              else
                Text('Este producto ya está reservado'),

              // Botón para editar el producto
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Ir a la pantalla de edición
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(product: _product),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Editar Producto'),
                ),
              ),

              // Botón para eliminar el producto
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _deleteProduct,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    textStyle: TextStyle(fontSize: 18),
                  ),
                  child: Text('Eliminar Producto'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
