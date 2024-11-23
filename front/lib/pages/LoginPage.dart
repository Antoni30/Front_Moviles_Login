import 'package:flutter/material.dart';
import 'package:front/pages/HomePage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginUser() async {
    final String username = usernameController.text;
    final String password = passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      // Mostrar un mensaje si los campos están vacíos
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Por favor, ingresa ambos campos"),
      ));
      return;
    }

    final Map<String, String> data = {
      "username": username,
      "password": password,
    };

    try {
      // Realizar la solicitud POST al servidor PHP
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/login.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['token'] != null) {
          // Si el login es exitoso, navegar a la HomePage con los datos
          final String token = responseBody['token'];
          final String username = responseBody['username']; // Cambiar por el nombre del usuario
          final String id = responseBody['ID'];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                token: token,
                username: username,
                id: id,
              ),
            ),
          );
        } else {
          // Error si no se recibe el token
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error en las credenciales"),
          ));
        }
      } else {
        // Si el código de estado no es 200, mostrar un error
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error en la conexión con el servidor"),
        ));
      }
    } catch (e) {
      // Manejar posibles errores en la solicitud
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: loginUser,
              child: Text('Login'),
            ),
             TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text('Create an Account'),
            )
          ],
        ),
      ),
    );
  }
}
