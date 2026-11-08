import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_providers.dart';
import '../../features/emotions/data/emotion_repository.dart';
import '../../features/pictograms/data/pictogram_repository.dart';
import '../../features/routines/data/routine_repository.dart';
import 'sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final localRepository = ref.watch(localAttemptRepositoryProvider);

  return SyncService(
    localRepository: localRepository,
    pictogramRepository: PictogramRepository(),
    emotionRepository: EmotionRepository(),
    routineRepository: RoutineRepository(),
  );
});
