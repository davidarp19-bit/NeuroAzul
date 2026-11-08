import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/profile_progress.dart';
import '../viewmodel/progress_viewmodel.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  final String profileId;

  const ProgressScreen({super.key, required this.profileId});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(progressViewModelProvider.notifier)
          .loadProgress(profileId: widget.profileId);
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(progressViewModelProvider.notifier)
        .refreshProgress(profileId: widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(progressViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi progreso'),
        leading: IconButton(
          onPressed: () {
            context.go('/child/${widget.profileId}/menu');
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualizar',
            onPressed: state.isLoading ? null : _refresh,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: SafeArea(child: _buildBody(state)),
    );
  }

  Widget _buildBody(ProgressState state) {
    if (state.isLoading && state.progress == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando progreso...',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    if (state.errorMessage != null && state.progress == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 60,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                'No pudimos cargar el progreso',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _refresh,
                icon: const Icon(Icons.refresh),
                label: const Text('Intentar nuevamente'),
              ),
            ],
          ),
        ),
      );
    }

    final progress = state.progress;

    if (progress == null) {
      return const Center(
        child: Text('No hay información de progreso disponible.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildGeneralProgress(progress),

                  const SizedBox(height: 24),

                  const Text(
                    'Resumen',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.check_circle_outline,
                          value: '${progress.completedActivities}',
                          label: 'Actividades completadas',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.touch_app_outlined,
                          value: '${progress.totalAttempts}',
                          label: 'Intentos realizados',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.done_all_outlined,
                          value: '${progress.totalCorrectAttempts}',
                          label: 'Respuestas correctas',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          icon: Icons.percent_outlined,
                          value: '${progress.accuracyPercentageValue}%',
                          label: 'Precisión',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Progreso por actividad',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ActivityProgressCard(
                    icon: Icons.image_outlined,
                    title: 'Pictogramas',
                    completed: progress.completedPictogramActivities,
                    total: 3,
                    attempts: progress.pictogramAttempts,
                    correct: progress.correctPictograms,
                  ),

                  const SizedBox(height: 12),

                  _ActivityProgressCard(
                    icon: Icons.sentiment_satisfied_alt_outlined,
                    title: 'Emociones',
                    completed: progress.completedEmotionActivities,
                    total: 3,
                    attempts: progress.emotionAttempts,
                    correct: progress.correctEmotions,
                  ),

                  const SizedBox(height: 12),

                  _ActivityProgressCard(
                    icon: Icons.format_list_numbered,
                    title: 'Rutinas',
                    completed: progress.completedRoutineActivities,
                    total: 2,
                    attempts: progress.routineAttempts,
                    correct: progress.correctRoutines,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralProgress(ProfileProgress progress) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.insights_outlined,
              size: 70,
              color: AppColors.primary,
            ),

            const SizedBox(height: 14),

            const Text(
              'Avance general',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              '${progress.completionPercentageValue}%',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: progress.completionPercentage,
              minHeight: 14,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 12),

            Text(
              '${progress.completedActivities} de '
              '${progress.totalActivities} actividades completadas',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Icon(icon, size: 34, color: AppColors.primary),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityProgressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int completed;
  final int total;
  final int attempts;
  final int correct;

  const _ActivityProgressCard({
    required this.icon,
    required this.title,
    required this.completed,
    required this.total,
    required this.attempts,
    required this.correct,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = total == 0 ? 0.0 : completed / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(icon, color: AppColors.primary),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                Text(
                  '$completed / $total',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            LinearProgressIndicator(
              value: percentage,
              minHeight: 10,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 14),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$attempts intentos',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
                Text(
                  '$correct correctos',
                  style: const TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
