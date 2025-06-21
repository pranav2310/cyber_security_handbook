import 'package:cyber_security/starting_grid.dart';
import 'package:flutter/material.dart';

final Color orange = const Color(0xFFF37022);
final Color blue = const Color(0xFF051951);
final Color white = const Color(0xFFFFFFFF);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cyber Security Handbook',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: orange
        ),
        iconTheme: IconThemeData(
          color: blue
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.light, 
          primary: orange, 
          onPrimary: blue, 
          secondary: white, 
          onSecondary: blue, 
          error: Colors.red,
          onError: white, 
          surface: blue, 
          onSurface: white
        )
      ),
      home: const StartingGrid(),
    );
  }
}
