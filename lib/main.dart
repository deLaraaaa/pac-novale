import 'package:flutter/material.dart';
import 'screens/show_business_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaleFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ShowBusinessScreen(),
    );
  }
}
