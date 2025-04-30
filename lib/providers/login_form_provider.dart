import 'package:flutter/material.dart';

// Clase la gestión del formulario de inicio de sesión
class LoginFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  // Variables para correo y contraseña
  String email = '';
  String password = '';

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Función para comprobar que el formulario sea correcto
  bool isValidForm() {
    print('Valor del formulario: ${formKey.currentState?.validate()}');
    print('$email - $password');
    return formKey.currentState?.validate() ?? false;
  }
}
