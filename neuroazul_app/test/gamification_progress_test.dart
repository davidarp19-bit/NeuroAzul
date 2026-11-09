import 'package:flutter_test/flutter_test.dart';
import 'package:neuroazul_app/features/gamification/data/gamification_progress.dart';

void main() {
  group('GamificationProgress', () {
    test('0 puntos corresponde al nivel Explorador', () {
      const progress = GamificationProgress(
        pictogramPoints: 0,
        emotionPoints: 0,
        routinePoints: 0,
        completedPictograms: 0,
        completedEmotions: 0,
        completedRoutines: 0,
      );

      expect(progress.totalPoints, 0);
      expect(progress.level, 1);
      expect(progress.levelName, 'Explorador');
      expect(progress.nextLevelPoints, 30);
      expect(progress.levelProgress, 0);
    });

    test('30 puntos corresponde al nivel Aventurero', () {
      const progress = GamificationProgress(
        pictogramPoints: 30,
        emotionPoints: 0,
        routinePoints: 0,
        completedPictograms: 3,
        completedEmotions: 0,
        completedRoutines: 0,
      );

      expect(progress.totalPoints, 30);
      expect(progress.level, 2);
      expect(progress.levelName, 'Aventurero');
      expect(progress.nextLevelPoints, 60);
      expect(progress.levelProgress, 0);
    });

    test('60 puntos corresponde al nivel Estrella Azul', () {
      const progress = GamificationProgress(
        pictogramPoints: 30,
        emotionPoints: 30,
        routinePoints: 0,
        completedPictograms: 3,
        completedEmotions: 3,
        completedRoutines: 0,
      );

      expect(progress.totalPoints, 60);
      expect(progress.level, 3);
      expect(progress.levelName, 'Estrella Azul');
      expect(progress.nextLevelPoints, 90);
      expect(progress.levelProgress, 0);
    });

    test('90 puntos corresponde al nivel Gran Explorador', () {
      const progress = GamificationProgress(
        pictogramPoints: 30,
        emotionPoints: 20,
        routinePoints: 40,
        completedPictograms: 3,
        completedEmotions: 2,
        completedRoutines: 2,
      );

      expect(progress.totalPoints, 90);
      expect(progress.level, 4);
      expect(progress.levelName, 'Gran Explorador');
      expect(progress.nextLevelPoints, 100);
      expect(progress.levelProgress, 1);
    });

    test('100 puntos desbloquea la recompensa maestra', () {
      const progress = GamificationProgress(
        pictogramPoints: 30,
        emotionPoints: 30,
        routinePoints: 40,
        completedPictograms: 3,
        completedEmotions: 3,
        completedRoutines: 2,
      );

      expect(progress.totalPoints, 100);
      expect(progress.level, 4);
      expect(progress.levelName, 'Gran Explorador');
      expect(progress.hasMasterReward, isTrue);
    });

    test('las recompensas se desbloquean según actividades completadas', () {
      const progress = GamificationProgress(
        pictogramPoints: 30,
        emotionPoints: 30,
        routinePoints: 40,
        completedPictograms: 3,
        completedEmotions: 3,
        completedRoutines: 2,
      );

      expect(progress.hasFirstPictogramReward, isTrue);
      expect(progress.hasPictogramReward, isTrue);
      expect(progress.hasEmotionReward, isTrue);
      expect(progress.hasRoutineReward, isTrue);
      expect(progress.hasMasterReward, isTrue);
    });

    test('las recompensas permanecen bloqueadas sin requisitos', () {
      const progress = GamificationProgress(
        pictogramPoints: 0,
        emotionPoints: 0,
        routinePoints: 0,
        completedPictograms: 0,
        completedEmotions: 0,
        completedRoutines: 0,
      );

      expect(progress.hasFirstPictogramReward, isFalse);
      expect(progress.hasPictogramReward, isFalse);
      expect(progress.hasEmotionReward, isFalse);
      expect(progress.hasRoutineReward, isFalse);
      expect(progress.hasMasterReward, isFalse);
    });

    test('el progreso dentro del nivel se calcula correctamente', () {
      const progress = GamificationProgress(
        pictogramPoints: 20,
        emotionPoints: 0,
        routinePoints: 20,
        completedPictograms: 2,
        completedEmotions: 0,
        completedRoutines: 1,
      );

      expect(progress.totalPoints, 40);
      expect(progress.level, 2);
      expect(progress.levelProgress, closeTo(10 / 30, 0.001));
    });
  });
}
