import 'dart:math';

class LevelCalculator {
  static const double baseXP = 200.0;
  static const double scalingFactor = 1.10;

  //calc cumulative XP = 1.10 multiplier
  //Level 1 = 0XP (10% more XP req'd compared to prev level)
  static int cumulativeXpForLevel(int level) {
    if (level <= 1) return 0;
    double total = 0;
    for (int l = 1; l < level; l++) {
      total += baseXP * pow(scalingFactor, l - 1);
    }
    return total.round();
  }

  //return leveldata based on total XP score
  static LevelData calculate(int totalXp) {
    if (totalXp < 0) totalXp = 0;

    int level = 1;
    while (true) {
      int nextLevelCumulXp = cumulativeXpForLevel(level + 1);
      if (totalXp < nextLevelCumulXp) {
        break;
      }
      level++;
    }

    int currentLevelCumulXp = cumulativeXpForLevel(level);
    int nextLevelCumulXp = cumulativeXpForLevel(level + 1);
    int xpReqForCurrentLevel = nextLevelCumulXp - currentLevelCumulXp;
    int xpCurrentLevel = totalXp - currentLevelCumulXp;
    double progress =
        xpReqForCurrentLevel > 0 ? xpCurrentLevel / xpReqForCurrentLevel : 0.0;
    int xpRemaining = nextLevelCumulXp - totalXp;

    return LevelData(
      level: level,
      xpCurrentLevel: xpCurrentLevel,
      xpReqForCurrentLevel: xpReqForCurrentLevel,
      progress: progress,
      xpRemaining: xpRemaining,
    );
  }
}

class LevelData {
  final int level;
  final int xpCurrentLevel;
  final int xpReqForCurrentLevel;
  final double progress;
  final int xpRemaining;

  LevelData({
    required this.level,
    required this.xpCurrentLevel,
    required this.xpReqForCurrentLevel,
    required this.progress,
    required this.xpRemaining,
  });
}
