class GamificationProgress {
  final int pictogramPoints;
  final int emotionPoints;
  final int routinePoints;

  final int completedPictograms;
  final int completedEmotions;
  final int completedRoutines;

  const GamificationProgress({
    required this.pictogramPoints,
    required this.emotionPoints,
    required this.routinePoints,
    required this.completedPictograms,
    required this.completedEmotions,
    required this.completedRoutines,
  });

  int get totalPoints => pictogramPoints + emotionPoints + routinePoints;

  int get level {
    if (totalPoints >= 90) {
      return 4;
    }

    if (totalPoints >= 60) {
      return 3;
    }

    if (totalPoints >= 30) {
      return 2;
    }

    return 1;
  }

  String get levelName {
    switch (level) {
      case 4:
        return 'Gran Explorador';
      case 3:
        return 'Estrella Azul';
      case 2:
        return 'Aventurero';
      default:
        return 'Explorador';
    }
  }

  int get nextLevelPoints {
    switch (level) {
      case 1:
        return 30;
      case 2:
        return 60;
      case 3:
        return 90;
      default:
        return 100;
    }
  }

  double get levelProgress {
    if (level == 4) {
      return 1;
    }

    switch (level) {
      case 1:
        return totalPoints / 30;
      case 2:
        return (totalPoints - 30) / 30;
      case 3:
        return (totalPoints - 60) / 30;
      default:
        return 0;
    }
  }

  bool get hasFirstPictogramReward => completedPictograms >= 1;

  bool get hasPictogramReward => completedPictograms >= 3;

  bool get hasEmotionReward => completedEmotions >= 3;

  bool get hasRoutineReward => completedRoutines >= 2;

  bool get hasMasterReward => totalPoints >= 100;
}
