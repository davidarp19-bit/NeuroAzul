import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/child_profile.dart';
import '../viewmodel/profile_viewmodel.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String profileId;

  const EditProfileScreen({
    super.key,
    required this.profileId,
  });

  @override
  ConsumerState<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aliasController = TextEditingController();

  String? _selectedAgeRange;
  bool _initializing = true;
  ChildProfile? _profile;

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

    if (profile != null) {
      _aliasController.text = profile.alias;

      setState(() {
        _profile = profile;
        _selectedAgeRange = profile.ageRange;
        _initializing = false;
      });
    } else {
      setState(() {
        _initializing = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAgeRange == null) {
      return;
    }

    final success = await ref
        .read(profileViewModelProvider.notifier)
        .updateProfile(
          profileId: widget.profileId,
          alias: _aliasController.text,
          ageRange: _selectedAgeRange!,
          avatarKey: _profile?.avatarKey,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Perfil actualizado correctamente.',
          ),
        ),
      );

      context.go('/profiles');
    } else {
      final error =
          ref.read(profileViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ??
                'No fue posible actualizar el perfil.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState =
        ref.watch(profileViewModelProvider);

    if (_initializing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar perfil infantil'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_profile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Editar perfil infantil'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 70,
                  color: AppColors.primary,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No fue posible encontrar el perfil.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    context.go('/profiles');
                  },
                  child: const Text(
                    'Volver a perfiles',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar perfil infantil'),
        leading: IconButton(
          onPressed: () {
            context.go('/profiles');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 80,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Editar perfil',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _aliasController,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        labelText: 'Nombre o alias',
                        prefixIcon: Icon(
                          Icons.person_outline,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null ||
                            value.trim().isEmpty) {
                          return 'Ingresa un nombre o alias';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedAgeRange,
                      decoration: const InputDecoration(
                        labelText: 'Rango de edad',
                        prefixIcon: Icon(
                          Icons.cake_outlined,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: '6-8',
                          child: Text('6 a 8 años'),
                        ),
                        DropdownMenuItem(
                          value: '9-10',
                          child: Text('9 a 10 años'),
                        ),
                        DropdownMenuItem(
                          value: '11-12',
                          child: Text('11 a 12 años'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAgeRange = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Selecciona un rango de edad';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 32),

                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed:
                            profileState.isLoading
                                ? null
                                : _saveChanges,
                        icon: profileState.isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.save_outlined,
                              ),
                        label: Text(
                          profileState.isLoading
                              ? 'Guardando...'
                              : 'Guardar cambios',
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}