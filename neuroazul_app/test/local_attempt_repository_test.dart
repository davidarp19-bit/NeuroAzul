import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroazul_app/core/database/app_database.dart';
import 'package:neuroazul_app/core/database/local_attempt_repository.dart';

void main() {
  late AppDatabase database;
  late LocalAttemptRepository repository;

  setUp(() {
    database = AppDatabase.forTesting(NativeDatabase.memory());

    repository = LocalAttemptRepository(database: database);
  });

  tearDown(() async {
    await database.close();
  });

  group('LocalAttemptRepository', () {
    test('guarda un intento local como pendiente de sincronización', () async {
      await repository.saveAttempt(
        profileId: 'profile-1',
        activityType: 'pictogram',
        activityId: 'question_house',
        selectedValue: 'house',
        isCorrect: true,
      );

      final attempts = await repository.getAttemptsForProfile(
        profileId: 'profile-1',
      );

      expect(attempts.length, 1);

      final attempt = attempts.first;

      expect(attempt.profileId, 'profile-1');
      expect(attempt.activityType, 'pictogram');
      expect(attempt.activityId, 'question_house');
      expect(attempt.selectedValue, 'house');
      expect(attempt.isCorrect, isTrue);
      expect(attempt.isSynced, isFalse);
      expect(attempt.clientAttemptId, isNotEmpty);
    });

    test('cuenta correctamente los intentos pendientes', () async {
      await repository.saveAttempt(
        profileId: 'profile-1',
        activityType: 'pictogram',
        activityId: 'question_house',
        selectedValue: 'house',
        isCorrect: true,
      );

      await repository.saveAttempt(
        profileId: 'profile-1',
        activityType: 'emotion',
        activityId: 'question_happy',
        selectedValue: 'happy',
        isCorrect: true,
      );

      await repository.saveAttempt(
        profileId: 'profile-2',
        activityType: 'pictogram',
        activityId: 'question_water',
        selectedValue: 'water',
        isCorrect: true,
      );

      expect(await repository.countPendingAttempts(), 3);

      expect(await repository.countPendingAttempts(profileId: 'profile-1'), 2);

      expect(await repository.countPendingAttempts(profileId: 'profile-2'), 1);
    });

    test('filtra los intentos según el perfil', () async {
      await repository.saveAttempt(
        profileId: 'profile-1',
        activityType: 'emotion',
        activityId: 'question_happy',
        selectedValue: 'happy',
        isCorrect: true,
      );

      await repository.saveAttempt(
        profileId: 'profile-2',
        activityType: 'emotion',
        activityId: 'question_sad',
        selectedValue: 'sad',
        isCorrect: false,
      );

      final profileOne = await repository.getAttemptsForProfile(
        profileId: 'profile-1',
      );

      final profileTwo = await repository.getAttemptsForProfile(
        profileId: 'profile-2',
      );

      expect(profileOne.length, 1);
      expect(profileTwo.length, 1);

      expect(profileOne.first.activityId, 'question_happy');

      expect(profileTwo.first.activityId, 'question_sad');
    });

    test('marca un intento como sincronizado', () async {
      final localId = await repository.saveAttempt(
        profileId: 'profile-1',
        activityType: 'pictogram',
        activityId: 'question_water',
        selectedValue: 'water',
        isCorrect: true,
      );

      await repository.markAsSynced(localId: localId, remoteId: 'remote-123');

      final attempts = await repository.getAttemptsForProfile(
        profileId: 'profile-1',
      );

      expect(attempts.length, 1);
      expect(attempts.first.isSynced, isTrue);
      expect(attempts.first.remoteId, 'remote-123');
    });

    test(
      'un intento sincronizado deja de aparecer entre los pendientes',
      () async {
        final firstId = await repository.saveAttempt(
          profileId: 'profile-1',
          activityType: 'pictogram',
          activityId: 'question_house',
          selectedValue: 'house',
          isCorrect: true,
        );

        await repository.saveAttempt(
          profileId: 'profile-1',
          activityType: 'emotion',
          activityId: 'question_happy',
          selectedValue: 'happy',
          isCorrect: true,
        );

        expect(
          await repository.countPendingAttempts(profileId: 'profile-1'),
          2,
        );

        await repository.markAsSynced(localId: firstId);

        final pending = await repository.getPendingAttempts(
          profileId: 'profile-1',
        );

        expect(pending.length, 1);
        expect(pending.first.activityType, 'emotion');
        expect(pending.first.isSynced, isFalse);
      },
    );
  });
}
