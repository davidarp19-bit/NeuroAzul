import 'package:flutter_test/flutter_test.dart';
import 'package:neuroazul_app/features/progress/data/profile_progress.dart';

void main() {
  group('ProfileProgress', () {
    test('sin intentos los indicadores permanecen en cero', () {
      const progress = ProfileProgress(
        pictogramAttempts: 0,
        correctPictograms: 0,
        emotionAttempts: 0,
        correctEmotions: 0,
        routineAttempts: 0,
        correctRoutines: 0,
        completedPictogramActivities: 0,
        completedEmotionActivities: 0,
        completedRoutineActivities: 0,
      );

      expect(progress.totalAttempts, 0);
      expect(progress.totalCorrectAttempts, 0);
      expect(progress.completedActivities, 0);
      expect(progress.completionPercentage, 0);
      expect(progress.completionPercentageValue, 0);
      expect(progress.accuracyPercentage, 0);
      expect(progress.accuracyPercentageValue, 0);
    });

    test('calcula correctamente el total de intentos', () {
      const progress = ProfileProgress(
        pictogramAttempts: 3,
        correctPictograms: 2,
        emotionAttempts: 4,
        correctEmotions: 3,
        routineAttempts: 2,
        correctRoutines: 1,
        completedPictogramActivities: 2,
        completedEmotionActivities: 2,
        completedRoutineActivities: 1,
      );

      expect(progress.totalAttempts, 9);
    });

    test('calcula correctamente el total de respuestas correctas', () {
      const progress = ProfileProgress(
        pictogramAttempts: 3,
        correctPictograms: 2,
        emotionAttempts: 4,
        correctEmotions: 3,
        routineAttempts: 2,
        correctRoutines: 1,
        completedPictogramActivities: 2,
        completedEmotionActivities: 2,
        completedRoutineActivities: 1,
      );

      expect(progress.totalCorrectAttempts, 6);
    });

    test('calcula correctamente las actividades completadas', () {
      const progress = ProfileProgress(
        pictogramAttempts: 3,
        correctPictograms: 3,
        emotionAttempts: 2,
        correctEmotions: 2,
        routineAttempts: 1,
        correctRoutines: 1,
        completedPictogramActivities: 3,
        completedEmotionActivities: 2,
        completedRoutineActivities: 1,
      );

      expect(progress.completedActivities, 6);
      expect(progress.totalActivities, 8);
    });

    test(
      'cuatro de ocho actividades corresponden a 50 por ciento de avance',
      () {
        const progress = ProfileProgress(
          pictogramAttempts: 2,
          correctPictograms: 2,
          emotionAttempts: 1,
          correctEmotions: 1,
          routineAttempts: 1,
          correctRoutines: 1,
          completedPictogramActivities: 2,
          completedEmotionActivities: 1,
          completedRoutineActivities: 1,
        );

        expect(progress.completedActivities, 4);
        expect(progress.completionPercentage, 0.5);
        expect(progress.completionPercentageValue, 50);
      },
    );

    test('ocho actividades completadas corresponden a 100 por ciento', () {
      const progress = ProfileProgress(
        pictogramAttempts: 3,
        correctPictograms: 3,
        emotionAttempts: 3,
        correctEmotions: 3,
        routineAttempts: 2,
        correctRoutines: 2,
        completedPictogramActivities: 3,
        completedEmotionActivities: 3,
        completedRoutineActivities: 2,
      );

      expect(progress.completedActivities, 8);
      expect(progress.completionPercentage, 1);
      expect(progress.completionPercentageValue, 100);
    });

    test('calcula correctamente el porcentaje de precisión', () {
      const progress = ProfileProgress(
        pictogramAttempts: 4,
        correctPictograms: 2,
        emotionAttempts: 2,
        correctEmotions: 1,
        routineAttempts: 2,
        correctRoutines: 1,
        completedPictogramActivities: 2,
        completedEmotionActivities: 1,
        completedRoutineActivities: 1,
      );

      expect(progress.totalAttempts, 8);
      expect(progress.totalCorrectAttempts, 4);
      expect(progress.accuracyPercentage, 0.5);
      expect(progress.accuracyPercentageValue, 50);
    });

    test('el porcentaje de precisión se redondea correctamente', () {
      const progress = ProfileProgress(
        pictogramAttempts: 1,
        correctPictograms: 1,
        emotionAttempts: 1,
        correctEmotions: 1,
        routineAttempts: 1,
        correctRoutines: 0,
        completedPictogramActivities: 1,
        completedEmotionActivities: 1,
        completedRoutineActivities: 0,
      );

      expect(progress.totalAttempts, 3);
      expect(progress.totalCorrectAttempts, 2);
      expect(progress.accuracyPercentage, closeTo(2 / 3, 0.001));
      expect(progress.accuracyPercentageValue, 67);
    });

    test('repetir intentos no implica completar más actividades', () {
      const progress = ProfileProgress(
        pictogramAttempts: 5,
        correctPictograms: 3,
        emotionAttempts: 4,
        correctEmotions: 2,
        routineAttempts: 3,
        correctRoutines: 1,
        completedPictogramActivities: 1,
        completedEmotionActivities: 1,
        completedRoutineActivities: 0,
      );

      expect(progress.totalAttempts, 12);
      expect(progress.completedActivities, 2);
      expect(progress.completionPercentageValue, 25);
    });
  });
}
