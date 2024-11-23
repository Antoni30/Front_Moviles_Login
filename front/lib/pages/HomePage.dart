import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front/pages/EditarPAge.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  final String token;
  final String username;
  final String id;

  HomePage({required this.token, required this.username, required this.id});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String nombreCompleto = '';
  String email = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final url = Uri.parse('http://localhost:8000/api/read_user.php?id=${widget.id}');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          nombreCompleto = data['nombre_completo'] ?? 'Nombre no disponible';
          email = data['email'] ?? 'Correo no disponible';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al obtener datos del usuario')),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void navigateToEditPage() async {
    final updatedData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPage(
          id: widget.id,
          username: widget.username,
          nombreCompleto: nombreCompleto,
          email: email,
        ),
      ),
    );

    if (updatedData != null) {
      setState(() {
        nombreCompleto = updatedData['nombre_completo'];
        email = updatedData['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Bienvenido, ${widget.username}',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nombre Completo: $nombreCompleto',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Correo Electrónico: $email',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Tu Token JWT:',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  SelectableText(
                    widget.token,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/');
                    },
                    child: Text('Logout'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: navigateToEditPage,
                    child: Text('Editar'),
                  ),
                ],
              ),
            ),
    );
  }
}
