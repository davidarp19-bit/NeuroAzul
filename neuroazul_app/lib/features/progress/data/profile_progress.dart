class ProfileProgress {
  final int pictogramAttempts;
  final int correctPictograms;
  final int emotionAttempts;
  final int correctEmotions;
  final int routineAttempts;
  final int correctRoutines;

  final int completedPictogramActivities;
  final int completedEmotionActivities;
  final int completedRoutineActivities;

  const ProfileProgress({
    required this.pictogramAttempts,
    required this.correctPictograms,
    required this.emotionAttempts,
    required this.correctEmotions,
    required this.routineAttempts,
    required this.correctRoutines,
    required this.completedPictogramActivities,
    required this.completedEmotionActivities,
    required this.completedRoutineActivities,
  });

  int get totalAttempts =>
      pictogramAttempts + emotionAttempts + routineAttempts;

  int get totalCorrectAttempts =>
      correctPictograms + correctEmotions + correctRoutines;

  int get completedActivities =>
      completedPictogramActivities +
      completedEmotionActivities +
      completedRoutineActivities;

  int get totalActivities => 8;

  double get completionPercentage {
    if (totalActivities == 0) {
      return 0;
    }

    return completedActivities / totalActivities;
  }

  int get completionPercentageValue => (completionPercentage * 100).round();

  double get accuracyPercentage {
    if (totalAttempts == 0) {
      return 0;
    }

    return totalCorrectAttempts / totalAttempts;
  }

  int get accuracyPercentageValue => (accuracyPercentage * 100).round();
}
