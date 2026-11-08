import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'local_attempt_repository.dart';
import 'local_profile_repository.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase();

  ref.onDispose(() {
    database.close();
  });

  return database;
});

final localAttemptRepositoryProvider = Provider<LocalAttemptRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);

  return LocalAttemptRepository(database: database);
});

final localProfileRepositoryProvider = Provider<LocalProfileRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);

  return LocalProfileRepository(database: database);
});

final localDatabaseWarmupProvider = FutureProvider<void>((ref) async {
  final database = ref.watch(appDatabaseProvider);

  await database.select(database.localAttempts).get();

  await database.select(database.localChildProfiles).get();
});
