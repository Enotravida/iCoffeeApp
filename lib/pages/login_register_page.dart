import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errorMessage = '';
  bool isLogin = true;
  bool _obscureText = true;  // Añadido para ocultar/mostrar la contraseña

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

Future<void> signInWithEmailAndPassword() async {
  try {
    if (_controllerPassword.text.isEmpty) {
      // Si la contraseña está vacía, solo verificamos si el email existe
      final signInMethods = await FirebaseAuth.instance.fetchSignInMethodsForEmail(_controllerEmail.text);
      if (signInMethods.isEmpty) {
        setState(() {
          errorMessage = "Correo no registrado";
        });
        return;
      }
    } else {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );
      // Iniciar sesión exitoso, puedes realizar acciones adicionales aquí
    }
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message;
    });
  }
}


Future<void> createUserWithEmailAndPassword() async {
  if (_controllerPassword.text.isEmpty) {
    setState(() {
      errorMessage = "Por favor, ingrese una contraseña.";
    });
    return;
  }

  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
    // Registro exitoso, puedes realizar acciones adicionales aquí
  } on FirebaseAuthException catch (e) {
    setState(() {
      errorMessage = e.message;
    });
  }
}

  Widget _title() {
    return const Text("iCoffeeApp");
  }

  Widget _entryField(String title, TextEditingController controller, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _obscureText : false,
      decoration: InputDecoration(
        labelText: title,
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
      ),
    );
  }

  Widget _errorMessage() {
      return Text(errorMessage ?? "");
  }

  Widget _submitButton() {
    return ElevatedButton(
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      child: Text(isLogin ? 'Iniciar sesión' : 'Registrar'),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(isLogin ? 'Registrar' : 'Iniciar sesión'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _title(),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _entryField('Email', _controllerEmail),
            _entryField('Contraseña', _controllerPassword, isPassword: true),
            _errorMessage(),
            _submitButton(),
            _loginOrRegisterButton(),
          ],
        ),
      ),
    );
  }
}
