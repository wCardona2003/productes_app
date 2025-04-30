import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:productes_app/providers/login_form_provider.dart';
import 'package:productes_app/ui/input_decorations.dart';
import 'package:productes_app/widgets/widgets.dart';
import 'package:productes_app/providers/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 250),
              CardContainer(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Text('Registrarse',
                        style: Theme.of(context).textTheme.headlineMedium),
                    SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _RegisterForm(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                child: Text('Ya tienes una cuenta? Iniciar sesión'),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecorations.authInputDecoration(
              hintText: 'john.doe@gmail.com',
              labelText: 'Correo electrónico',
              prefixIcon: Icons.alternate_email_outlined,
            ),
            onChanged: (value) => loginForm.email = value,
            validator: (value) {
              String pattern =
                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
              RegExp regExp = RegExp(pattern);
              return regExp.hasMatch(value!) ? null : 'No es un correo valido';
            },
          ),
          SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            obscureText: true,
            decoration: InputDecorations.authInputDecoration(
              hintText: '*****',
              labelText: 'Contraseña',
              prefixIcon: Icons.lock_outline,
            ),
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              return (value != null && value.length >= 6)
                  ? null
                  : 'Mínimo 6 caracteres';
            },
          ),
          SizedBox(height: 30),
          MaterialButton(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(
                loginForm.isLoading ? 'Espere' : 'Registrar',
                style: TextStyle(color: Colors.white),
              ),
            ),
            onPressed: loginForm.isLoading
                ? null
                : () async {
              FocusScope.of(context).unfocus();
              if (!loginForm.isValidForm()) return;

              loginForm.isLoading = true;

              final authService = AuthService();
              final errorMessage = await authService.createUser(
                loginForm.email,
                loginForm.password,
              );

              if (errorMessage == null) {
                Navigator.pushReplacementNamed(context, 'home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(errorMessage)),
                );
              }

              loginForm.isLoading = false;
            },
          )
        ],
      ),
    );
  }
}
