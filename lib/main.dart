import 'package:flutter/material.dart';
import 'package:productes_app/screens/register_screen.dart';
import 'package:productes_app/screens/screens.dart';
import 'package:productes_app/screens/register_product.dart';
import 'package:productes_app/screens/product_screen.dart'; // Asegúrate de importar la pantalla ProductScreen
import 'package:productes_app/models/product.dart';

import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Productes App',
      initialRoute: 'login',
      routes: {
        'login': (_) => LoginScreen(),
        'home': (_) => HomeScreen(),
        'register': (_) => const RegisterScreen(),
        'add_product': (_) => RegisterProductScreen(),
        'product_screen': (context) {
          final product = ModalRoute.of(context)!.settings.arguments as Product;
          return ProductScreen(product: product);
        },

      },
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.grey[300],
      ),
    );
  }
}
