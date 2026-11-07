import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../profile/data/avatar_option.dart';
import '../../profile/data/child_profile.dart';
import '../../profile/viewmodel/profile_viewmodel.dart';

class ChildMenuScreen extends ConsumerStatefulWidget {
  final String profileId;

  const ChildMenuScreen({super.key, required this.profileId});

  @override
  ConsumerState<ChildMenuScreen> createState() => _ChildMenuScreenState();
}

class _ChildMenuScreenState extends ConsumerState<ChildMenuScreen> {
  ChildProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    final profile = await ref
        .read(profileViewModelProvider.notifier)
        .getProfileById(widget.profileId);

    if (!mounted) return;

    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('NeuroAzul')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('NeuroAzul')),
        body: Center(
          child: FilledButton(
            onPressed: () {
              context.go('/profiles');
            },
            child: const Text('Volver a perfiles'),
          ),
        ),
      );
    }

    AvatarOption? selectedAvatar;

    for (final avatar in avatarOptions) {
      if (avatar.key == _profile!.avatarKey) {
        selectedAvatar = avatar;
        break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('NeuroAzul'),
        leading: IconButton(
          tooltip: 'Cambiar perfil',
          onPressed: () {
            context.go('/profiles');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 700),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: AppColors.primaryLight,
                    child: Icon(
                      selectedAvatar?.icon ?? Icons.face_outlined,
                      size: 55,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    '¡Hola, ${_profile!.alias}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  if (selectedAvatar != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      'Avatar: ${selectedAvatar.name}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  const Text(
                    '¿Qué quieres hacer hoy?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 32),

                  _MenuCard(
                    icon: Icons.face_outlined,
                    title: 'Mi avatar',
                    description: 'Elige el personaje que te representa.',
                    onTap: () {
                      context.go('/child/${widget.profileId}/avatar');
                    },
                  ),

                  const SizedBox(height: 16),

                  _MenuCard(
                    icon: Icons.image_outlined,
                    title: 'Pictogramas',
                    description: 'Aprende y relaciona imágenes.',
                    onTap: () {
                      context.go('/child/${widget.profileId}/pictograms');
                    },
                  ),

                  const SizedBox(height: 16),

                  _MenuCard(
                    icon: Icons.sentiment_satisfied_alt_outlined,
                    title: 'Emociones',
                    description: 'Reconoce alegría, tristeza y enojo.',
                    onTap: () {
                      context.go('/child/${widget.profileId}/emotions');
                    },
                  ),

                  const SizedBox(height: 16),

                  _MenuCard(
                    icon: Icons.format_list_numbered,
                    title: 'Rutinas',
                    description: 'Organiza actividades paso a paso.',
                    onTap: () {
                      context.go('/child/${widget.profileId}/routines');
                    },
                  ),

                  const SizedBox(height: 16),

                  _MenuCard(
                    icon: Icons.emoji_events_outlined,
                    title: 'Mis logros',
                    description: 'Consulta puntos y recompensas.',
                    onTap: () {
                      context.go('/child/${widget.profileId}/rewards');
                    },
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

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryLight,
                child: Icon(icon, size: 30, color: AppColors.primary),
              ),

              const SizedBox(width: 18),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }
}
