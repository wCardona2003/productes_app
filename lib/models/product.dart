// Modelo del producto
class Product {
  String? id;             // Id
  String name;            // Nombre
  double price;           // Precio
  bool available;         // Disponibilidad
  String? imageUrl;       // Link de la imagen
  String? description;    // Descripción del producto

  Product({
    this.id,
    required this.name,
    required this.price,
    this.available = true,
    this.imageUrl,
    this.description,
  });

  // Convertir a JSON para el correcto envío a la base de datos
  Map<String, dynamic> toJson() => {
    'name': name,
    'price': price,
    'available': available,
    'imageUrl': imageUrl,
    'description': description,
  };

  // Convertir desde JSON para leer de base de datos
  static Product fromJson(Map<String, dynamic> json) => Product(
    name: json['name'],
    price: (json['price'] as num).toDouble(),
    available: json['available'],
    imageUrl: json['imageUrl'],
    description: json['description'],
  );
}
