import 'package:flutter/material.dart';

import './screens/home_screen.dart';

void main() {
  runApp(const kosApp());
}

class kosApp extends StatelessWidget {
  const kosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SiKos',
      theme: ThemeData(colorSchemeSeed: Colors.blue, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
