import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
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
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}