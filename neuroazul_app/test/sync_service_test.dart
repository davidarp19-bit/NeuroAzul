import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:neuroazul_app/core/database/app_database.dart';
import 'package:neuroazul_app/core/database/local_attempt_repository.dart';
import 'package:neuroazul_app/core/sync/sync_service.dart';
import 'package:neuroazul_app/features/emotions/data/emotion_repository.dart';
import 'package:neuroazul_app/features/pictograms/data/pictogram_repository.dart';
import 'package:neuroazul_app/features/routines/data/routine_repository.dart';

class MockLocalAttemptRepository extends Mock
    implements LocalAttemptRepository {}

class MockPictogramRepository extends Mock implements PictogramRepository {}

class MockEmotionRepository extends Mock implements EmotionRepository {}

class MockRoutineRepository extends Mock implements RoutineRepository {}

LocalAttempt createAttempt({
  required int id,
  required String activityType,
  required String activityId,
  required String selectedValue,
  bool isCorrect = true,
}) {
  return LocalAttempt(
    id: id,
    clientAttemptId: 'client-$id',
    profileId: 'profile-1',
    activityType: activityType,
    activityId: activityId,
    selectedValue: selectedValue,
    isCorrect: isCorrect,
    createdAt: DateTime(2026, 1, 1),
    isSynced: false,
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String>[]);
  });

  late MockLocalAttemptRepository localRepository;
  late MockPictogramRepository pictogramRepository;
  late MockEmotionRepository emotionRepository;
  late MockRoutineRepository routineRepository;
  late SyncService syncService;

  setUp(() {
    localRepository = MockLocalAttemptRepository();
    pictogramRepository = MockPictogramRepository();
    emotionRepository = MockEmotionRepository();
    routineRepository = MockRoutineRepository();

    syncService = SyncService(
      localRepository: localRepository,
      pictogramRepository: pictogramRepository,
      emotionRepository: emotionRepository,
      routineRepository: routineRepository,
    );
  });

  group('SyncService', () {
    test('obtiene correctamente la cantidad de intentos pendientes', () async {
      when(() => localRepository.countPendingAttempts(profileId: 'profile-1'))
          .thenAnswer((_) async => 3);

      final result = await syncService.getPendingCount(profileId: 'profile-1');

      expect(result, 3);

      verify(() => localRepository.countPendingAttempts(profileId: 'profile-1'))
          .called(1);
    });

    test('sincroniza correctamente un pictograma pendiente', () async {
      final attempt = createAttempt(
        id: 1,
        activityType: 'pictogram',
        activityId: 'question_house',
        selectedValue: 'house',
      );

      when(() => localRepository.getPendingAttempts(profileId: null))
          .thenAnswer((_) async => [attempt]);

      when(
        () => pictogramRepository.registerAttempt(
          profileId: 'profile-1',
          questionId: 'question_house',
          selectedId: 'house',
          isCorrect: true,
        ),
      ).thenAnswer((_) async {});

      when(() => localRepository.markAsSynced(localId: 1))
          .thenAnswer((_) async {});

      final result = await syncService.syncPendingAttempts();

      expect(result, 1);

      verify(
        () => pictogramRepository.registerAttempt(
          profileId: 'profile-1',
          questionId: 'question_house',
          selectedId: 'house',
          isCorrect: true,
        ),
      ).called(1);

      verify(() => localRepository.markAsSynced(localId: 1)).called(1);
    });

    test('sincroniza correctamente una emoción pendiente', () async {
      final attempt = createAttempt(
        id: 2,
        activityType: 'emotion',
        activityId: 'question_happy',
        selectedValue: 'happy',
      );

      when(() => localRepository.getPendingAttempts(profileId: null))
          .thenAnswer((_) async => [attempt]);

      when(
        () => emotionRepository.registerAttempt(
          profileId: 'profile-1',
          questionId: 'question_happy',
          selectedEmotion: 'happy',
          isCorrect: true,
        ),
      ).thenAnswer((_) async {});

      when(() => localRepository.markAsSynced(localId: 2))
          .thenAnswer((_) async {});

      final result = await syncService.syncPendingAttempts();

      expect(result, 1);

      verify(
        () => emotionRepository.registerAttempt(
          profileId: 'profile-1',
          questionId: 'question_happy',
          selectedEmotion: 'happy',
          isCorrect: true,
        ),
      ).called(1);

      verify(() => localRepository.markAsSynced(localId: 2)).called(1);
    });

    test('reconstruye y sincroniza correctamente una rutina', () async {
      final attempt = createAttempt(
        id: 3,
        activityType: 'routine',
        activityId: 'feeding',
        selectedValue: '["wash_hands","sit_at_table","eat_food","clean_up"]',
      );

      when(() => localRepository.getPendingAttempts(profileId: null))
          .thenAnswer((_) async => [attempt]);

      when(
        () => routineRepository.registerAttempt(
          profileId: 'profile-1',
          routineId: 'feeding',
          selectedOrder: any<List<String>>(named: 'selectedOrder'),
          isCorrect: true,
        ),
      ).thenAnswer((_) async {});

      when(() => localRepository.markAsSynced(localId: 3))
          .thenAnswer((_) async {});

      final result = await syncService.syncPendingAttempts();

      expect(result, 1);

      verify(
        () => routineRepository.registerAttempt(
          profileId: 'profile-1',
          routineId: 'feeding',
          selectedOrder: any<List<String>>(
            named: 'selectedOrder',
            that: equals([
              'wash_hands',
              'sit_at_table',
              'eat_food',
              'clean_up',
            ]),
          ),
          isCorrect: true,
        ),
      ).called(1);

      verify(() => localRepository.markAsSynced(localId: 3)).called(1);
    });

    test(
      'si falla la conexión remota el intento permanece pendiente',
      () async {
        final attempt = createAttempt(
          id: 4,
          activityType: 'pictogram',
          activityId: 'question_water',
          selectedValue: 'water',
        );

        when(() => localRepository.getPendingAttempts(profileId: null))
            .thenAnswer((_) async => [attempt]);

        when(
          () => pictogramRepository.registerAttempt(
            profileId: 'profile-1',
            questionId: 'question_water',
            selectedId: 'water',
            isCorrect: true,
          ),
        ).thenThrow(Exception('Sin conexión'));

        final result = await syncService.syncPendingAttempts();

        expect(result, 0);

        verifyNever(() => localRepository.markAsSynced(localId: 4));
      },
    );

    test('un tipo desconocido no se marca como sincronizado', () async {
      final attempt = createAttempt(
        id: 5,
        activityType: 'unknown',
        activityId: 'unknown_activity',
        selectedValue: 'value',
      );

      when(() => localRepository.getPendingAttempts(profileId: null))
          .thenAnswer((_) async => [attempt]);

      final result = await syncService.syncPendingAttempts();

      expect(result, 0);

      verifyNever(() => localRepository.markAsSynced(localId: 5));

      verifyNever(
        () => pictogramRepository.registerAttempt(
          profileId: any(named: 'profileId'),
          questionId: any(named: 'questionId'),
          selectedId: any(named: 'selectedId'),
          isCorrect: any(named: 'isCorrect'),
        ),
      );

      verifyNever(
        () => emotionRepository.registerAttempt(
          profileId: any(named: 'profileId'),
          questionId: any(named: 'questionId'),
          selectedEmotion: any(named: 'selectedEmotion'),
          isCorrect: any(named: 'isCorrect'),
        ),
      );
    });
  });
}
