import '../models/card_model.dart';
import '../models/player_model.dart';

class AIService {
  /// Evaluates the best move for the AI.
  /// Returns the card to play and the target index in the opponent's field (if any).
  /// If targetIndex is -1, it means no specific target (or attack face if applicable, but here we attack cards).
  /// Returns null if no move is possible or beneficial.
  (CardModel?, int) calculateMove(Player aiPlayer, Player opponent) {
    CardModel? bestCard;
    int bestTargetIndex = -1;
    double bestScore = -double.infinity;

    // Filter playable cards based on energy
    final playableCards = aiPlayer.hand
        .where((c) => c.cost <= aiPlayer.currentEnergy)
        .toList();

    if (playableCards.isEmpty) {
      return (null, -1);
    }

    for (final card in playableCards) {
      // Scenario 1: Attack an opponent card
      if (opponent.field.isNotEmpty) {
        for (int i = 0; i < opponent.field.length; i++) {
          final target = opponent.field[i];
          final score = _evaluateMove(card, target, aiPlayer, opponent);
          if (score > bestScore) {
            bestScore = score;
            bestCard = card;
            bestTargetIndex = i;
          }
        }
      } else {
        // Scenario 2: Play on empty board (no target to attack immediately upon entry if rules require target)
        // Assuming rules: "Ao jogar, deve escolher uma carta inimiga para receber o dano da carta"
        // If no enemy cards, maybe we just play for board presence?
        // Let's assume we can play without a target if none exist.
        final score = _evaluateBoardPresence(card);
        if (score > bestScore) {
          bestScore = score;
          bestCard = card;
          bestTargetIndex = -1;
        }
      }
    }

    return (bestCard, bestTargetIndex);
  }

  double _evaluateMove(
    CardModel card,
    CardModel target,
    Player ai,
    Player opponent,
  ) {
    double score = 0;

    // 1. Destruction Value
    if (card.atk >= target.currentHp) {
      score += 100; // Huge bonus for destroying a card
      score += target.cost * 10; // Bonus for destroying expensive cards
    } else {
      // 2. Damage Value
      score += card.atk * 2; // Value damage
    }

    // 3. Self Preservation / Board Presence
    score += card.hp; // Prefer high HP cards to stick around
    score += card.atk; // Prefer high ATK cards for future threats

    // 4. Efficiency
    // Penalize wasting energy? Maybe not needed if we just want best impact.
    // score -= card.cost; // Slight penalty for high cost? No, we want to spend energy.

    return score;
  }

  double _evaluateBoardPresence(CardModel card) {
    // Simple heuristic: stats per cost
    return (card.hp + card.atk).toDouble() +
        (card.cost * 5); // Bias towards playing expensive cards when possible
  }
}
