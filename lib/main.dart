import 'package:cyber_security/screens/starting_grid.dart';
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
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: orange,
          onPrimary: white,       // Text/icons on orange
          secondary: blue,        // Accent color
          onSecondary: white,     // Text/icons on blue
          error: Colors.red,
          onError: white,
          surface: white,         // Cards/sheets background
          onSurface: blue,        // Text/icons on surface
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: orange,
          foregroundColor: white, // Text/icons in AppBar
          iconTheme: IconThemeData(color: white),
        ),
        iconTheme: IconThemeData(
          color: blue,
        ),
        scaffoldBackgroundColor: white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const StartingGrid(),
    );
  }
}
