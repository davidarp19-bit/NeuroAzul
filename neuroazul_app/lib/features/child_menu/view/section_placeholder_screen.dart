import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';

class SectionPlaceholderScreen extends StatelessWidget {
  final String profileId;
  final String title;
  final IconData icon;

  const SectionPlaceholderScreen({
    super.key,
    required this.profileId,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          onPressed: () {
            context.go('/child/$profileId/menu');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 90, color: AppColors.primary),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Esta actividad se implementará en un próximo sprint.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 17, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 28),
              OutlinedButton.icon(
                onPressed: () {
                  context.go('/child/$profileId/menu');
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Volver al menú'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
