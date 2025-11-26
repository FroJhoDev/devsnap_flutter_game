class TurnService {
  static const int maxRounds = 6;

  int getEnergyForRound(int round) {
    return round;
  }

  bool isGameFinished(int currentRound) {
    return currentRound > maxRounds;
  }
}
