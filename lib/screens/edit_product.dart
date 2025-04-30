import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/product_provider.dart';

// Pantalla de edición del producto
class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final ProductService _productService = ProductService();

  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    _nameController.text = _product.name;
    _priceController.text = _product.price.toString();
    _descriptionController.text = _product.description ?? '';
    _imageUrlController.text = _product.imageUrl ?? '';
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final updatedProduct = Product(
      id: _product.id,
      name: _nameController.text,
      price: double.parse(_priceController.text),
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
      available: _product.available,  // Mantenemos la disponibilidad actual
    );

    await _productService.saveProduct(updatedProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto actualizado con éxito')),
    );

    Navigator.pop(context, true); // Regresar a la pantalla anterior y pasar el valor 'true'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Producto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nombre del Producto'),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
                validator: (value) => value!.isEmpty || double.tryParse(value) == null
                    ? 'Introduce un precio válido'
                    : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Descripción'),
                validator: (value) => value!.isEmpty ? 'Este campo es obligatorio' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(labelText: 'URL de la imagen'),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Guardar Producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
