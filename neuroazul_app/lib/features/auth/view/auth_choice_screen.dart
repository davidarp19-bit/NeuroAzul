import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroAzul'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                children: [
                  const Icon(
                    Icons.family_restroom_outlined,
                    size: 80,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Acceso para adulto responsable',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Ingresa a tu cuenta o crea una nueva para gestionar los perfiles infantiles.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.5,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'Iniciar sesión',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: const Text(
                        'Crear cuenta',
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextButton.icon(
                    onPressed: () {
                      context.go('/');
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Volver'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}