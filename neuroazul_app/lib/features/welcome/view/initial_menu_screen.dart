import 'package:flutter/material.dart';

class InitialMenuScreen extends StatelessWidget {
  const InitialMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroAzul'),
        centerTitle: true,
        backgroundColor: const Color(0xFFE7F0F8),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.waving_hand_outlined,
                size: 70,
                color: Color(0xFF4F7CAC),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Bienvenido a NeuroAzul!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF294C60),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Muy pronto aquí podrás crear tu perfil y comenzar las actividades.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                  color: Color(0xFF4A5568),
                ),
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}