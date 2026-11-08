import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/routine_step.dart';
import '../viewmodel/routine_viewmodel.dart';

class FeedingRoutineScreen extends ConsumerStatefulWidget {
  final String profileId;

  const FeedingRoutineScreen({super.key, required this.profileId});

  @override
  ConsumerState<FeedingRoutineScreen> createState() =>
      _FeedingRoutineScreenState();
}

class _FeedingRoutineScreenState extends ConsumerState<FeedingRoutineScreen> {
  late List<RoutineStep> _steps;
  bool? _isCorrect;

  @override
  void initState() {
    super.initState();

    _steps = [
      feedingRoutineSteps[2],
      feedingRoutineSteps[0],
      feedingRoutineSteps[3],
      feedingRoutineSteps[1],
    ];
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final step = _steps.removeAt(oldIndex);

      _steps.insert(newIndex, step);

      _isCorrect = null;
    });
  }

  Future<void> _checkSequence() async {
    bool correct = true;

    for (int index = 0; index < _steps.length; index++) {
      if (_steps[index].correctPosition != index + 1) {
        correct = false;
        break;
      }
    }

    final selectedOrder = _steps.map((step) => step.id).toList();

    final saved = await ref
        .read(routineViewModelProvider.notifier)
        .registerAttempt(
          profileId: widget.profileId,
          routineId: 'feeding',
          selectedOrder: selectedOrder,
          isCorrect: correct,
        );

    if (!mounted) return;

    if (!saved) {
      final error = ref.read(routineViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'No fue posible registrar el intento.'),
        ),
      );

      return;
    }

    setState(() {
      _isCorrect = correct;
    });
  }

  void _resetSequence() {
    setState(() {
      _steps = [
        feedingRoutineSteps[2],
        feedingRoutineSteps[0],
        feedingRoutineSteps[3],
        feedingRoutineSteps[1],
      ];

      _isCorrect = null;
    });
  }

  void _showCompletionDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          icon: const Icon(
            Icons.celebration_outlined,
            size: 50,
            color: AppColors.primary,
          ),
          title: const Text('¡Rutina completada!', textAlign: TextAlign.center),
          content: const Text(
            'Organizaste correctamente la rutina de alimentación.',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();

                context.go('/child/${widget.profileId}/menu');
              },
              child: const Text('Volver al menú'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final routineState = ref.watch(routineViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rutina de alimentación'),
        leading: IconButton(
          onPressed: () {
            context.go('/child/${widget.profileId}/menu');
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Text(
                    'Ordena la rutina de alimentación',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Mantén presionado un paso y muévelo hasta colocarlo en el orden correcto.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: true,
                      itemCount: _steps.length,
                      onReorder: routineState.isSaving ? (_, __) {} : _reorder,
                      itemBuilder: (context, index) {
                        final step = _steps[index];

                        return Card(
                          key: ValueKey(step.id),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              child: Icon(step.icon, color: AppColors.primary),
                            ),
                            title: Text(
                              step.label,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            subtitle: Text('Posición ${index + 1}'),
                            trailing: const Icon(Icons.drag_handle),
                          ),
                        );
                      },
                    ),
                  ),

                  if (routineState.isSaving) ...[
                    const SizedBox(height: 12),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 8),
                    const Text(
                      'Registrando intento...',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],

                  if (_isCorrect == true)
                    _RoutineFeedbackCard(
                      icon: Icons.check_circle_outline,
                      message: '¡Muy bien! Organizaste correctamente la rutina de alimentación.',
                      actionText: 'Finalizar',
                      onPressed: _showCompletionDialog,
                    ),

                  if (_isCorrect == false)
                    _RoutineFeedbackCard(
                      icon: Icons.refresh_outlined,
                      message:
                          'Aún puedes cambiar el orden. Inténtalo nuevamente.',
                      actionText: 'Seguir intentando',
                      onPressed: () {
                        setState(() {
                          _isCorrect = null;
                        });
                      },
                    ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: routineState.isSaving
                              ? null
                              : _resetSequence,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reiniciar'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: FilledButton.icon(
                          onPressed: routineState.isSaving
                              ? null
                              : _checkSequence,
                          icon: const Icon(Icons.check),
                          label: const Text('Comprobar'),
                        ),
                      ),
                    ],
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

class _RoutineFeedbackCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionText;
  final VoidCallback onPressed;

  const _RoutineFeedbackCard({
    required this.icon,
    required this.message,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, size: 42, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onPressed, child: Text(actionText)),
          ],
        ),
      ),
    );
  }
}
