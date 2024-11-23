import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EditPage extends StatefulWidget {
  final String id;
  final String username;
  final String nombreCompleto;
  final String email;

  EditPage({
    required this.id,
    required this.username,
    required this.nombreCompleto,
    required this.email,
  });

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController nombreController;
  late TextEditingController emailController;

  @override
  void initState() {
    super.initState();
    nombreController = TextEditingController(text: widget.nombreCompleto);
    emailController = TextEditingController(text: widget.email);
  }

  Future<void> updateUser() async {
  final url = Uri.parse('http://localhost:8000/api/update_user.php');
  final body = jsonEncode({
    'id': widget.id,
    'username': widget.username,
    'email': emailController.text,
    'nombre_completo': nombreController.text,
  });

  try {
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Datos actualizados con éxito')),
      );

      // Devolver los datos actualizados al HomePage
      Navigator.pop(context, {
        'nombre_completo': nombreController.text,
        'email': emailController.text,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar los datos: ${response.body}')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Usuario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'ID',
              ),
              controller: TextEditingController(text: widget.id),
            ),
            SizedBox(height: 10),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
              controller: TextEditingController(text: widget.username),
            ),
            SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Correo Electrónico',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: nombreController,
              decoration: InputDecoration(
                labelText: 'Nombre Completo',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateUser,
              child: Text('Actualizar'),
            ),
          ],
        ),
      ),
    );
  }
}
