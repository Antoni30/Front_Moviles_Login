import 'package:flutter/material.dart';
import 'dart:convert'; // Para codificar el JSON
import 'package:http/http.dart' as http; // Biblioteca HTTP

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  Future<void> registerUser() async {
    // Construir el JSON
    final Map<String, String> data = {
      "username": usernameController.text,
      "password": passwordController.text,
      "email": emailController.text,
      "nombre_completo": nombreController.text,
    };

    try {
      // Realizar la solicitud POST
      final response = await http.post(
        Uri.parse('http://localhost:8000/api/crear_user.php'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      // Manejar la respuesta
      if (response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Usuario registrado con éxito")),
          );
          Navigator.pop(context); // Regresar al login
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${responseBody['message']}")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error del servidor: ${response.statusCode}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
                prefixIcon: Icon(Icons.person),
              ),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: Icon(Icons.account_circle),
              ),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
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
              onPressed: registerUser, // Llama a la función al presionar
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
