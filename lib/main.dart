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
      title: 'Cybersecurity Guide',
      theme: ThemeData(useMaterial3: true),
      home: StartingGrid(),
    );
  }
}
