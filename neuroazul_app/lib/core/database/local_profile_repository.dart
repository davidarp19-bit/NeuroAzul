import 'package:drift/drift.dart';

import 'app_database.dart';

class LocalProfileRepository {
  final AppDatabase _database;

  LocalProfileRepository({required AppDatabase database})
    : _database = database;

  Future<void> cacheProfile({
    required String profileId,
    required String adultId,
    required String alias,
    required String ageRange,
    String? avatarKey,
  }) async {
    await _database
        .into(_database.localChildProfiles)
        .insertOnConflictUpdate(
          LocalChildProfilesCompanion.insert(
            profileId: profileId,
            adultId: adultId,
            alias: alias,
            ageRange: ageRange,
            avatarKey: Value(avatarKey),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<LocalChildProfile?> getProfileById({required String profileId}) async {
    final query = _database.select(_database.localChildProfiles)
      ..where((table) => table.profileId.equals(profileId));

    return query.getSingleOrNull();
  }

  Future<List<LocalChildProfile>> getProfilesForAdult({
    required String adultId,
  }) async {
    final query = _database.select(_database.localChildProfiles)
      ..where((table) => table.adultId.equals(adultId))
      ..orderBy([(table) => OrderingTerm.asc(table.alias)]);

    return query.get();
  }

  Future<void> deleteProfile({required String profileId}) async {
    await (_database.delete(
      _database.localChildProfiles,
    )..where((table) => table.profileId.equals(profileId))).go();
  }
}
