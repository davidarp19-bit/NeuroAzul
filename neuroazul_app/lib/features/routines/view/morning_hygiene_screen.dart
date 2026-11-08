import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/routine_step.dart';

class MorningHygieneScreen extends StatefulWidget {
  final String profileId;

  const MorningHygieneScreen({super.key, required this.profileId});

  @override
  State<MorningHygieneScreen> createState() => _MorningHygieneScreenState();
}

class _MorningHygieneScreenState extends State<MorningHygieneScreen> {
  late List<RoutineStep> _steps;

  bool? _isCorrect;

  @override
  void initState() {
    super.initState();

    // Orden inicial deliberadamente diferente
    // al orden correcto.
    _steps = [
      morningHygieneSteps[2],
      morningHygieneSteps[0],
      morningHygieneSteps[3],
      morningHygieneSteps[1],
    ];
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }

      final step = _steps.removeAt(oldIndex);
      _steps.insert(newIndex, step);

      // Al mover nuevamente un elemento,
      // eliminamos la retroalimentación anterior.
      _isCorrect = null;
    });
  }

  void _checkSequence() {
    bool correct = true;

    for (int index = 0; index < _steps.length; index++) {
      if (_steps[index].correctPosition != index + 1) {
        correct = false;
        break;
      }
    }

    setState(() {
      _isCorrect = correct;
    });
  }

  void _resetSequence() {
    setState(() {
      _steps = [
        morningHygieneSteps[2],
        morningHygieneSteps[0],
        morningHygieneSteps[3],
        morningHygieneSteps[1],
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
            'Organizaste correctamente la rutina de higiene de la mañana.',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Higiene matutina'),
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
                    'Ordena tu rutina de la mañana',
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
                      onReorder: _reorder,
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

                  if (_isCorrect == true)
                    _RoutineFeedbackCard(
                      icon: Icons.check_circle_outline,
                      message:
                          '¡Muy bien! Organizaste correctamente la rutina.',
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
                          onPressed: _resetSequence,
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reiniciar'),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _checkSequence,
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
