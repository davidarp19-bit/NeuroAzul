import 'package:flutter/material.dart';

import 'features/welcome/view/welcome_screen.dart';

void main() {
  runApp(const NeuroAzulApp());
}

class NeuroAzulApp extends StatelessWidget {
  const NeuroAzulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NeuroAzul',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F7CAC),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF7FAFC),
      ),
      home: const WelcomeScreen(),
    );
  }
}