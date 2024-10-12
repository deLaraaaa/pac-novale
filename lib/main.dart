import 'package:flutter/material.dart';
import 'screens/show_business_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NovaleFlow',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShowBusinessScreen(),
    );
  }
}
