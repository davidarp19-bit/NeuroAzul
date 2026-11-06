import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../auth/viewmodel/auth_viewmodel.dart';

class InitialMenuScreen extends ConsumerWidget {
  const InitialMenuScreen({super.key});

  Future<void> _logout(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final success = await ref
        .read(authViewModelProvider.notifier)
        .logout();

    if (!context.mounted) return;

    if (success) {
      context.go('/auth');
    } else {
      final error =
          ref.read(authViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ?? 'No fue posible cerrar la sesión.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final authState = ref.watch(authViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroAzul'),
        actions: [
          IconButton(
            tooltip: 'Cerrar sesión',
            onPressed: authState.isLoading
                ? null
                : () => _logout(context, ref),
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.waving_hand_outlined,
                size: 70,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Bienvenido a NeuroAzul!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Muy pronto aquí podrás crear y gestionar los perfiles infantiles.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 17,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}