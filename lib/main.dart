import 'package:cyber_security/starting_grid.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CyberGuard Handbook',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color.fromARGB(255, 37, 131, 224)
        ),
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.light, 
          primary: Color.fromARGB(255, 37, 131, 224), 
          onPrimary: Color(0xFFFFFFFF), 
          secondary: Color(0xFF3ad0ff), 
          onSecondary: Color(0xFFB3B3B3), 
          error: Colors.red,
          onError: Colors.black, 
          surface: Color(0xFF22396e), 
          onSurface: Color.fromARGB(255, 213, 235, 254)
        )
      ),
      home: const StartingGrid(),
    );
  }
}
