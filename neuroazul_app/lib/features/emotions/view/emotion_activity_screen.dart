import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/emotion_item.dart';
import '../viewmodel/emotion_viewmodel.dart';

class EmotionActivityScreen extends ConsumerStatefulWidget {
  final String profileId;

  const EmotionActivityScreen({super.key, required this.profileId});

  @override
  ConsumerState<EmotionActivityScreen> createState() =>
      _EmotionActivityScreenState();
}

class _EmotionActivityScreenState extends ConsumerState<EmotionActivityScreen> {
  int _currentQuestion = 0;
  String? _selectedId;
  bool? _isCorrect;

  final List<_EmotionQuestion> _questions = const [
    _EmotionQuestion(
      id: 'emotion_happy',
      prompt: '¿Cómo se siente una persona cuando recibe una buena noticia?',
      correctId: 'happy',
    ),
    _EmotionQuestion(
      id: 'emotion_sad',
      prompt:
          '¿Cómo se siente una persona cuando pierde algo que quería mucho?',
      correctId: 'sad',
    ),
    _EmotionQuestion(
      id: 'emotion_angry',
      prompt: '¿Cómo se siente una persona cuando algo le molesta mucho?',
      correctId: 'angry',
    ),
  ];

  Future<void> _selectEmotion(String id) async {
    final question = _questions[_currentQuestion];

    final isCorrect = id == question.correctId;

    final saved = await ref
        .read(emotionViewModelProvider.notifier)
        .registerAttempt(
          profileId: widget.profileId,
          questionId: question.id,
          selectedEmotion: id,
          isCorrect: isCorrect,
        );

    if (!mounted) return;

    if (!saved) {
      final error = ref.read(emotionViewModelProvider).errorMessage;

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
            'Terminaste la actividad de reconocimiento de emociones.',
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

    final emotionState = ref.watch(emotionViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Emociones'),
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

                  const SizedBox(height: 32),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: emotionItems.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.9,
                        ),
                    itemBuilder: (context, index) {
                      final emotion = emotionItems[index];

                      final isSelected = _selectedId == emotion.id;

                      return InkWell(
                        borderRadius: BorderRadius.circular(18),
                        onTap: emotionState.isSaving || _isCorrect == true
                            ? null
                            : () {
                                _selectEmotion(emotion.id);
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
                                emotion.icon,
                                size: 64,
                                color: AppColors.primary,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                emotion.label,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
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

                  if (emotionState.isSaving) ...[
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
                    _EmotionFeedbackCard(
                      icon: Icons.check_circle_outline,
                      message: '¡Muy bien! Reconociste la emoción.',
                      actionText: _currentQuestion == _questions.length - 1
                          ? 'Finalizar'
                          : 'Siguiente',
                      onPressed: _nextQuestion,
                    ),

                  if (_isCorrect == false)
                    _EmotionFeedbackCard(
                      icon: Icons.refresh_outlined,
                      message: 'Puedes intentarlo otra vez. Observa las opciones con calma.',
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

class _EmotionQuestion {
  final String id;
  final String prompt;
  final String correctId;

  const _EmotionQuestion({
    required this.id,
    required this.prompt,
    required this.correctId,
  });
}

class _EmotionFeedbackCard extends StatelessWidget {
  final IconData icon;
  final String message;
  final String actionText;
  final VoidCallback onPressed;

  const _EmotionFeedbackCard({
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
