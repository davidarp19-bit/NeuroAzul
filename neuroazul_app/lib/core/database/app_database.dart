import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';

part 'app_database.g.dart';

class LocalAttempts extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get clientAttemptId => text().unique()();

  TextColumn get profileId => text()();

  TextColumn get activityType => text()();

  TextColumn get activityId => text()();

  TextColumn get selectedValue => text()();

  BoolColumn get isCorrect => boolean()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  TextColumn get remoteId => text().nullable()();
}

class LocalChildProfiles extends Table {
  TextColumn get profileId => text()();

  TextColumn get adultId => text()();

  TextColumn get alias => text()();

  TextColumn get ageRange => text()();

  TextColumn get avatarKey => text().nullable()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

@DriftDatabase(tables: [LocalAttempts, LocalChildProfiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase()
    : super(
        driftDatabase(
          name: 'neuroazul_local',
          web: DriftWebOptions(
            sqlite3Wasm: Uri.parse('sqlite3.wasm'),
            driftWorker: Uri.parse('drift_worker.js'),
            onResult: (result) {
              debugPrint(
                'DRIFT implementation: '
                '${result.chosenImplementation}',
              );

              debugPrint(
                'DRIFT missing features: '
                '${result.missingFeatures}',
              );
            },
          ),
        ),
      );

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
      },
      onUpgrade: (migrator, from, to) async {
        if (from < 2) {
          await migrator.createTable(localChildProfiles);
        }
      },
    );
  }
}
