import 'dart:convert';

import '../database/local_attempt_repository.dart';
import '../../features/emotions/data/emotion_repository.dart';
import '../../features/pictograms/data/pictogram_repository.dart';
import '../../features/routines/data/routine_repository.dart';

class SyncService {
  final LocalAttemptRepository localRepository;
  final PictogramRepository pictogramRepository;
  final EmotionRepository emotionRepository;
  final RoutineRepository routineRepository;

  SyncService({
    required this.localRepository,
    required this.pictogramRepository,
    required this.emotionRepository,
    required this.routineRepository,
  });

  Future<int> getPendingCount({String? profileId}) async {
    return localRepository.countPendingAttempts(profileId: profileId);
  }

  Future<int> syncPendingAttempts({String? profileId}) async {
    final pendingAttempts = await localRepository.getPendingAttempts(
      profileId: profileId,
    );

    int synchronized = 0;

    for (final attempt in pendingAttempts) {
      try {
        switch (attempt.activityType) {
          case 'pictogram':
            await pictogramRepository.registerAttempt(
              profileId: attempt.profileId,
              questionId: attempt.activityId,
              selectedId: attempt.selectedValue,
              isCorrect: attempt.isCorrect,
            );

          case 'emotion':
            await emotionRepository.registerAttempt(
              profileId: attempt.profileId,
              questionId: attempt.activityId,
              selectedEmotion: attempt.selectedValue,
              isCorrect: attempt.isCorrect,
            );

          case 'routine':
            final decoded = jsonDecode(attempt.selectedValue);

            if (decoded is! List) {
              throw const FormatException(
                'La secuencia local de la rutina no es válida.',
              );
            }

            final selectedOrder = decoded
                .map((value) => value.toString())
                .toList();

            await routineRepository.registerAttempt(
              profileId: attempt.profileId,
              routineId: attempt.activityId,
              selectedOrder: selectedOrder,
              isCorrect: attempt.isCorrect,
            );

          default:
            continue;
        }

        await localRepository.markAsSynced(localId: attempt.id);

        synchronized++;
      } catch (_) {
        // El intento permanece con isSynced = false
        // para volver a intentarlo posteriormente.
      }
    }

    return synchronized;
  }
}
