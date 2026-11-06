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
    final authState =
        ref.watch(authViewModelProvider);

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
      body: SafeArea(
        child: Center(
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
                  'Aquí podrás crear y gestionar los perfiles infantiles.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    height: 1.5,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: 280,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.go('/profiles');
                    },
                    icon: const Icon(
                      Icons.people_outline,
                    ),
                    label: const Text(
                      'Ver perfiles infantiles',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: 280,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: () {
                      context.go('/profile/create');
                    },
                    icon: const Icon(
                      Icons.person_add_alt_1_outlined,
                    ),
                    label: const Text(
                      'Crear perfil infantil',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}