import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/avatar_option.dart';
import '../data/child_profile.dart';
import '../viewmodel/profile_viewmodel.dart';

class AvatarSelectionScreen extends ConsumerStatefulWidget {
  final String profileId;

  const AvatarSelectionScreen({super.key, required this.profileId});

  @override
  ConsumerState<AvatarSelectionScreen> createState() =>
      _AvatarSelectionScreenState();
}

class _AvatarSelectionScreenState extends ConsumerState<AvatarSelectionScreen> {
  ChildProfile? _profile;
  String? _selectedAvatarKey;
  bool _initializing = true;

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
      _selectedAvatarKey = profile?.avatarKey;
      _initializing = false;
    });
  }

  Future<void> _saveAvatar() async {
    if (_profile == null || _selectedAvatarKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecciona un avatar antes de continuar.'),
        ),
      );
      return;
    }

    final success = await ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(
          profileId: _profile!.id,
          alias: _profile!.alias,
          ageRange: _profile!.ageRange,
          avatarKey: _selectedAvatarKey,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Avatar guardado correctamente.')),
      );

      context.go('/child/${widget.profileId}/menu');
    } else {
      final error = ref.read(profileViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'No fue posible guardar el avatar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileViewModelProvider);

    if (_initializing) {
      return Scaffold(
        appBar: AppBar(title: const Text('Elige tu avatar')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Elige tu avatar')),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Elige tu avatar'),
        leading: IconButton(
          onPressed: () {
            context.go('/child/${widget.profileId}/menu');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 650),
              child: Column(
                children: [
                  Text(
                    '¡Hola, ${_profile!.alias}!',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Selecciona el avatar que más te guste.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: avatarOptions.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                        ),
                    itemBuilder: (context, index) {
                      final avatar = avatarOptions[index];

                      final isSelected = avatar.key == _selectedAvatarKey;

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: () {
                          setState(() {
                            _selectedAvatarKey = avatar.key;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryLight
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey.shade300,
                              width: isSelected ? 3 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                avatar.icon,
                                size: 58,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                avatar.name,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(height: 8),
                                const Icon(
                                  Icons.check_circle,
                                  color: AppColors.primary,
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton.icon(
                      onPressed: profileState.isLoading ? null : _saveAvatar,
                      icon: profileState.isLoading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.save_outlined),
                      label: Text(
                        profileState.isLoading
                            ? 'Guardando...'
                            : 'Guardar avatar',
                        style: const TextStyle(fontSize: 17),
                      ),
                    ),
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
