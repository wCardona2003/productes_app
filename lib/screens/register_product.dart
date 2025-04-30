import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/product.dart';
import '../providers/product_provider.dart';
import '../providers/cloudinary_provider.dart';
import '../ui/input_decorations.dart';

// Pantalla para crear un producto nuevo
class RegisterProductScreen extends StatefulWidget {
  const RegisterProductScreen({Key? key}) : super(key: key);

  @override
  State<RegisterProductScreen> createState() => _RegisterProductScreenState();
}

class _RegisterProductScreenState extends State<RegisterProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  bool _available = true;

  final ProductService _productService = ProductService();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  // Función para elegir una imagen
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile == null) return;

    setState(() {
      _selectedImage = File(pickedFile.path);
    });

    final url = await CloudinaryProvider.uploadImage(_selectedImage!);
    if (url != null) {
      setState(() {
        _imageUrlController.text = url;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al subir la imagen')),
      );
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    final product = Product(
      name: _nameController.text,
      price: double.parse(_priceController.text),
      available: _available,
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text,
    );

    await _productService.saveProduct(product);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Producto añadido correctamente')),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Añadir producto')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del producto',
                  labelText: 'Nombre',
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Precio',
                  labelText: 'Precio (€)',
                ),
                validator: (value) =>
                value == null || double.tryParse(value) == null
                    ? 'Precio no valido'
                    : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Descripción',
                  labelText: 'Descripción',
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Campo obligatorio' : null,
              ),
              SizedBox(height: 20),

              Text('Seleccionar imagen:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(Icons.photo),
                    label: Text('Galeria'),
                    onPressed: () => _pickImage(ImageSource.gallery),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camara'),
                    onPressed: () => _pickImage(ImageSource.camera),
                  ),
                ],
              ),
              SizedBox(height: 10),
              if (_selectedImage != null)
                Image.file(_selectedImage!, height: 150),

              SizedBox(height: 20),
              TextFormField(
                controller: _imageUrlController,
                readOnly: true,
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'URL automática',
                  labelText: 'URL Imagen',
                ),
                validator: (value) =>
                value == null || value.isEmpty ? 'Subir una imagen' : null,
              ),
              SizedBox(height: 20),
              SwitchListTile(
                title: Text('Disponible'),
                value: _available,
                onChanged: (val) => setState(() => _available = val),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProduct,
                child: Text('Guardar producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
