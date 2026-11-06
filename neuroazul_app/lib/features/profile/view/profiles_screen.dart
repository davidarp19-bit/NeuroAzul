import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../viewmodel/profile_viewmodel.dart';

class ProfilesScreen extends ConsumerStatefulWidget {
  const ProfilesScreen({super.key});

  @override
  ConsumerState<ProfilesScreen> createState() =>
      _ProfilesScreenState();
}

class _ProfilesScreenState
    extends ConsumerState<ProfilesScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(profileViewModelProvider.notifier)
          .loadProfiles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState =
        ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfiles infantiles'),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.go('/profile/create');
        },
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Nuevo perfil'),
      ),

      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (profileState.isLoading &&
                profileState.profiles.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (profileState.errorMessage != null &&
                profileState.profiles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profileState.errorMessage!,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () {
                          ref
                              .read(
                                profileViewModelProvider
                                    .notifier,
                              )
                              .loadProfiles();
                        },
                        child: const Text(
                          'Intentar nuevamente',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (profileState.profiles.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.child_care_outlined,
                        size: 80,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Aún no hay perfiles infantiles',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Crea el primer perfil para comenzar a utilizar NeuroAzul.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: () {
                          context.go('/profile/create');
                        },
                        icon: const Icon(
                          Icons.person_add_alt_1,
                        ),
                        label: const Text(
                          'Crear perfil',
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(
                      profileViewModelProvider.notifier,
                    )
                    .loadProfiles();
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(24),
                itemCount:
                    profileState.profiles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final profile =
                      profileState.profiles[index];

                  return Card(
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      leading: const CircleAvatar(
                        backgroundColor:
                            AppColors.primaryLight,
                        child: Icon(
                          Icons.child_care_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        profile.alias,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        '${profile.ageRange} años',
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}