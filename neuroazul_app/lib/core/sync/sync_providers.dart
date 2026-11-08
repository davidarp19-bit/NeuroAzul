import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/database_providers.dart';
import '../../features/pictograms/data/pictogram_repository.dart';
import 'sync_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  final localRepository = ref.watch(localAttemptRepositoryProvider);

  return SyncService(
    localRepository: localRepository,
    pictogramRepository: PictogramRepository(),
  );
});
