import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../viewmodel/profile_viewmodel.dart';

class CreateProfileScreen extends ConsumerStatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  ConsumerState<CreateProfileScreen> createState() =>
      _CreateProfileScreenState();
}

class _CreateProfileScreenState
    extends ConsumerState<CreateProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aliasController = TextEditingController();

  String? _selectedAgeRange;

  @override
  void dispose() {
    _aliasController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedAgeRange == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecciona un rango de edad.',
          ),
        ),
      );
      return;
    }

    final success = await ref
        .read(profileViewModelProvider.notifier)
        .createProfile(
          alias: _aliasController.text,
          ageRange: _selectedAgeRange!,
        );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Perfil infantil creado correctamente.',
          ),
        ),
      );

      context.go('/home');
    } else {
      final error =
          ref.read(profileViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error ??
                'No fue posible crear el perfil.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState =
        ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crear perfil infantil',
        ),
        leading: IconButton(
          onPressed: () {
            context.go('/home');
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
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
                      Icons.child_care_outlined,
                      size: 80,
                      color: AppColors.primary,
                    ),

                    const SizedBox(height: 24),

                    const Text(
                      'Nuevo perfil infantil',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      'Usa un nombre o alias y selecciona el rango de edad.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),

                    const SizedBox(height: 32),

                    TextFormField(
                      controller: _aliasController,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        labelText: 'Nombre o alias',
                        hintText: 'Ejemplo: Luna',
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

                        if (value.trim().length > 40) {
                          return 'El alias no puede superar 40 caracteres';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    DropdownButtonFormField<String>(
                      initialValue:
                          _selectedAgeRange,
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
                          child: Text(
                            '6 a 8 años',
                          ),
                        ),
                        DropdownMenuItem(
                          value: '9-10',
                          child: Text(
                            '9 a 10 años',
                          ),
                        ),
                        DropdownMenuItem(
                          value: '11-12',
                          child: Text(
                            '11 a 12 años',
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedAgeRange =
                              value;
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
                                : _createProfile,
                        style:
                            FilledButton.styleFrom(
                          backgroundColor:
                              AppColors.primary,
                          foregroundColor:
                              Colors.white,
                        ),
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
                                Icons.add,
                              ),
                        label: Text(
                          profileState.isLoading
                              ? 'Creando perfil...'
                              : 'Crear perfil',
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