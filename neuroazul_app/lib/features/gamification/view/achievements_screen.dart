import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../data/gamification_progress.dart';
import '../viewmodel/gamification_viewmodel.dart';

class AchievementsScreen extends ConsumerStatefulWidget {
  final String profileId;

  const AchievementsScreen({super.key, required this.profileId});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref
          .read(gamificationViewModelProvider.notifier)
          .loadProgress(profileId: widget.profileId);
    });
  }

  Future<void> _refresh() async {
    await ref
        .read(gamificationViewModelProvider.notifier)
        .refreshProgress(profileId: widget.profileId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gamificationViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis logros'),
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

  Widget _buildBody(GamificationState state) {
    if (state.isLoading && state.progress == null) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Cargando tus logros...',
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
                'No pudimos cargar tus logros',
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
      return const Center(child: Text('No hay información disponible.'));
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
                  _buildHeader(progress),

                  const SizedBox(height: 24),

                  _buildLevelCard(progress),

                  const SizedBox(height: 24),

                  const Text(
                    'Tu progreso',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _ProgressCard(
                    icon: Icons.image_outlined,
                    title: 'Pictogramas',
                    completed: progress.completedPictograms,
                    total: 3,
                    points: progress.pictogramPoints,
                  ),

                  const SizedBox(height: 12),

                  _ProgressCard(
                    icon: Icons.sentiment_satisfied_alt_outlined,
                    title: 'Emociones',
                    completed: progress.completedEmotions,
                    total: 3,
                    points: progress.emotionPoints,
                  ),

                  const SizedBox(height: 12),

                  _ProgressCard(
                    icon: Icons.format_list_numbered,
                    title: 'Rutinas',
                    completed: progress.completedRoutines,
                    total: 2,
                    points: progress.routinePoints,
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Recompensas',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _RewardCard(
                    icon: Icons.emoji_events_outlined,
                    title: 'Primer paso',
                    description: 'Completa correctamente tu primer pictograma.',
                    unlocked: progress.hasFirstPictogramReward,
                  ),

                  const SizedBox(height: 12),

                  _RewardCard(
                    icon: Icons.collections_outlined,
                    title: 'Maestro de pictogramas',
                    description: 'Completa correctamente los tres pictogramas.',
                    unlocked: progress.hasPictogramReward,
                  ),

                  const SizedBox(height: 12),

                  _RewardCard(
                    icon: Icons.sentiment_very_satisfied_outlined,
                    title: 'Explorador de emociones',
                    description: 'Reconoce correctamente las tres emociones.',
                    unlocked: progress.hasEmotionReward,
                  ),

                  const SizedBox(height: 12),

                  _RewardCard(
                    icon: Icons.checklist_outlined,
                    title: 'Experto en rutinas',
                    description: 'Completa correctamente las dos rutinas.',
                    unlocked: progress.hasRoutineReward,
                  ),

                  const SizedBox(height: 12),

                  _RewardCard(
                    icon: Icons.workspace_premium_outlined,
                    title: 'NeuroAzul 100',
                    description: 'Alcanza los 100 puntos.',
                    unlocked: progress.hasMasterReward,
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(GamificationProgress progress) {
    return Column(
      children: [
        const Icon(Icons.emoji_events, size: 80, color: AppColors.primary),

        const SizedBox(height: 14),

        const Text(
          '¡Sigue aprendiendo!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          '${progress.totalPoints} puntos',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildLevelCard(GamificationProgress progress) {
    final maxLevel = progress.level == 4;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    '${progress.level}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nivel ${progress.level}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        progress.levelName,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(
              value: progress.levelProgress,
              minHeight: 12,
              borderRadius: BorderRadius.circular(20),
            ),

            const SizedBox(height: 10),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                maxLevel
                    ? '¡Alcanzaste el nivel máximo!'
                    : 'Siguiente nivel: ${progress.nextLevelPoints} puntos',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int completed;
  final int total;
  final int points;

  const _ProgressCard({
    required this.icon,
    required this.title,
    required this.completed,
    required this.total,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : completed / total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryLight,
              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  LinearProgressIndicator(value: progress),

                  const SizedBox(height: 7),

                  Text(
                    '$completed de $total completados',
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 14),

            Text(
              '+$points',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool unlocked;

  const _RewardCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.unlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27,
              backgroundColor: AppColors.primaryLight,
              child: Icon(
                unlocked ? icon : Icons.lock_outline,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    description,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Icon(
              unlocked ? Icons.check_circle : Icons.lock_outline,
              color: unlocked ? AppColors.primary : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
