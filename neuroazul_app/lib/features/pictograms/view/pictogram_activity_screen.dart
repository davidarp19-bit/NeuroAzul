import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/pictogram_item.dart';
import '../viewmodel/pictogram_viewmodel.dart';

class PictogramActivityScreen extends ConsumerStatefulWidget {
  final String profileId;

  const PictogramActivityScreen({super.key, required this.profileId});

  @override
  ConsumerState<PictogramActivityScreen> createState() =>
      _PictogramActivityScreenState();
}

class _PictogramActivityScreenState
    extends ConsumerState<PictogramActivityScreen> {
  int _currentQuestion = 0;
  String? _selectedId;
  bool? _isCorrect;

  final List<_PictogramQuestion> _questions = const [
    _PictogramQuestion(
      id: 'question_house',
      prompt: '¿Dónde está la casa?',
      correctId: 'house',
      optionIds: ['house', 'food', 'school'],
    ),
    _PictogramQuestion(
      id: 'question_water',
      prompt: '¿Cuál representa agua?',
      correctId: 'water',
      optionIds: ['play', 'water', 'bed'],
    ),
    _PictogramQuestion(
      id: 'question_school',
      prompt: '¿Dónde aprendemos y estudiamos?',
      correctId: 'school',
      optionIds: ['school', 'house', 'play'],
    ),
  ];

  PictogramItem _findItem(String id) {
    return pictogramItems.firstWhere((item) => item.id == id);
  }

  Future<void> _selectAnswer(String id) async {
    final question = _questions[_currentQuestion];

    final isCorrect = id == question.correctId;

    final saved = await ref
        .read(pictogramViewModelProvider.notifier)
        .registerAttempt(
          profileId: widget.profileId,
          questionId: question.id,
          selectedId: id,
          isCorrect: isCorrect,
        );

    if (!mounted) return;

    if (!saved) {
      final error = ref.read(pictogramViewModelProvider).errorMessage;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? 'No fue posible registrar la respuesta.'),
        ),
      );

      return;
    }

    setState(() {
      _selectedId = id;
      _isCorrect = isCorrect;
    });
  }

  void _tryAgain() {
    setState(() {
      _selectedId = null;
      _isCorrect = null;
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedId = null;
        _isCorrect = null;
      });
    } else {
      _showCompletionDialog();
    }
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
          title: const Text(
            '¡Actividad completada!',
            textAlign: TextAlign.center,
          ),
          content: const Text(
            'Terminaste esta actividad de pictogramas.',
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
    final question = _questions[_currentQuestion];

    final pictogramState = ref.watch(pictogramViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pictogramas'),
        leading: IconButton(
          onPressed: () {
            context.go('/child/${widget.profileId}/menu');
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
                  Text(
                    'Actividad ${_currentQuestion + 1} '
                    'de ${_questions.length}',
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    question.prompt,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 30),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: question.optionIds.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.9,
                        ),
                    itemBuilder: (context, index) {
                      final item = _findItem(question.optionIds[index]);

                      final isSelected = _selectedId == item.id;

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: pictogramState.isSaving || _isCorrect == true
                            ? null
                            : () {
                                _selectAnswer(item.id);
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
                                item.icon,
                                size: 58,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item.label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  if (pictogramState.isSaving) ...[
                    const SizedBox(height: 24),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 10),
                    const Text(
                      'Registrando respuesta...',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],

                  const SizedBox(height: 28),

                  if (_isCorrect == true)
                    _FeedbackCard(
                      icon: Icons.check_circle_outline,
                      message: '¡Muy bien! Elegiste la respuesta correcta.',
                      actionText: _currentQuestion == _questions.length - 1
                          ? 'Finalizar'
                          : 'Siguiente',
                      onPressed: _nextQuestion,
                    ),

                  if (_isCorrect == false)
                    _FeedbackCard(
                      icon: Icons.refresh_outlined,
                      message: 'Inténtalo nuevamente. Puedes volver a elegir.',
                      actionText: 'Intentar otra vez',
                      onPressed: _tryAgain,
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

class _PictogramQuestion {
  final String id;
  final String prompt;
  final String correctId;
  final List<String> optionIds;

  const _PictogramQuestion({
    required this.id,
    required this.prompt,
    required this.correctId,
    required this.optionIds,
  });
}

class _FeedbackCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionText;
  final VoidCallback onPressed;

  const _FeedbackCard({
    required this.icon,
    required this.message,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 45, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onPressed, child: Text(actionText)),
          ],
        ),
      ),
    );
  }
}
