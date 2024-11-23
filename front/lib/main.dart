import 'package:flutter/material.dart';
import 'package:front/pages/HomePage.dart';
import 'package:front/pages/LoginPage.dart';
import 'package:front/pages/RegisterPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/home': (context) => HomePage(token: '', username: '',id: '',),
      },
    );
  }
}