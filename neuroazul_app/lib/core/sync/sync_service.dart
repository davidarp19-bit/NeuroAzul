import '../database/local_attempt_repository.dart';
import '../../features/pictograms/data/pictogram_repository.dart';

class SyncService {
  final LocalAttemptRepository localRepository;
  final PictogramRepository pictogramRepository;

  SyncService({
    required this.localRepository,
    required this.pictogramRepository,
  });

  Future<int> getPendingCount({String? profileId}) async {
    return localRepository.countPendingAttempts(profileId: profileId);
  }

  Future<int> syncPendingPictograms({String? profileId}) async {
    final pendingAttempts = await localRepository.getPendingAttempts(
      profileId: profileId,
    );

    int synchronized = 0;

    for (final attempt in pendingAttempts) {
      if (attempt.activityType != 'pictogram') {
        continue;
      }

      try {
        await pictogramRepository.registerAttempt(
          profileId: attempt.profileId,
          questionId: attempt.activityId,
          selectedId: attempt.selectedValue,
          isCorrect: attempt.isCorrect,
        );

        await localRepository.markAsSynced(localId: attempt.id);

        synchronized++;
      } catch (_) {
        // Se mantiene pendiente para un nuevo intento.
      }
    }

    return synchronized;
  }
}
