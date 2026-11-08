import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

class LocalAttemptRepository {
  final AppDatabase _database;
  final Uuid _uuid;

  LocalAttemptRepository({
    required AppDatabase database,
    Uuid uuid = const Uuid(),
  }) : _database = database,
       _uuid = uuid;

  Future<int> saveAttempt({
    required String profileId,
    required String activityType,
    required String activityId,
    required String selectedValue,
    required bool isCorrect,
  }) async {
    return _database
        .into(_database.localAttempts)
        .insert(
          LocalAttemptsCompanion.insert(
            clientAttemptId: _uuid.v4(),
            profileId: profileId,
            activityType: activityType,
            activityId: activityId,
            selectedValue: selectedValue,
            isCorrect: isCorrect,
            createdAt: Value(DateTime.now()),
            isSynced: const Value(false),
          ),
        );
  }

  Future<List<LocalAttempt>> getPendingAttempts({String? profileId}) async {
    final query = _database.select(_database.localAttempts)
      ..where((table) => table.isSynced.equals(false));

    if (profileId != null) {
      query.where((table) => table.profileId.equals(profileId));
    }

    query.orderBy([(table) => OrderingTerm.asc(table.createdAt)]);

    return query.get();
  }

  Future<int> countPendingAttempts({String? profileId}) async {
    final attempts = await getPendingAttempts(profileId: profileId);

    return attempts.length;
  }

  Future<void> markAsSynced({required int localId, String? remoteId}) async {
    await (_database.update(
      _database.localAttempts,
    )..where((table) => table.id.equals(localId))).write(
      LocalAttemptsCompanion(
        isSynced: const Value(true),
        remoteId: Value(remoteId),
      ),
    );
  }

  Future<List<LocalAttempt>> getAttemptsForProfile({
    required String profileId,
  }) async {
    final query = _database.select(_database.localAttempts)
      ..where((table) => table.profileId.equals(profileId))
      ..orderBy([(table) => OrderingTerm.desc(table.createdAt)]);

    return query.get();
  }
}
