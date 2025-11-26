import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/player_model.dart';
import '../models/card_model.dart';
import '../services/deck_service.dart';
import '../services/turn_service.dart';
import '../services/ai_service.dart';

class GameViewModel extends ChangeNotifier {
  final DeckService _deckService;
  final TurnService _turnService;
  final AIService _aiService;

  late GameState _state;
  GameState get state => _state;

  GameViewModel({
    required DeckService deckService,
    required TurnService turnService,
    required AIService aiService,
  }) : _deckService = deckService,
       _turnService = turnService,
       _aiService = aiService {
    _initializeGame();
  }

  void _initializeGame() {
    final playerDeck = _deckService.shuffleDeck(_deckService.getInitialDeck());
    final opponentDeck = _deckService.shuffleDeck(
      _deckService.getInitialDeck(),
    );

    // Initial draw (3 cards)
    final (playerHand, playerRemainingDeck) = _deckService.drawCards(
      [],
      playerDeck,
      3,
    );
    final (opponentHand, opponentRemainingDeck) = _deckService.drawCards(
      [],
      opponentDeck,
      3,
    );

    final player = Player(
      id: 'player',
      name: 'Player',
      deck: playerRemainingDeck,
      hand: playerHand,
      totalEnergy: 1,
      currentEnergy: 1,
    );

    final opponent = Player(
      id: 'ai',
      name: 'AI',
      deck: opponentRemainingDeck,
      hand: opponentHand,
      totalEnergy: 1,
      currentEnergy: 1,
    );

    _state = GameState(
      player: player,
      opponent: opponent,
      currentRound: 1,
      phase: GamePhase
          .draw, // Start in draw phase, but we just drew, so maybe play?
    );

    // Move to play phase immediately after setup
    _state = _state.copyWith(phase: GamePhase.play);
    notifyListeners();
  }

  void playCard(CardModel card, {int targetIndex = -1}) {
    if (_state.phase != GamePhase.play) return;
    if (card.cost > _state.player.currentEnergy) return;

    // Remove from hand
    final newHand = List<CardModel>.from(_state.player.hand)..remove(card);

    // Add to field
    final newField = List<CardModel>.from(_state.player.field)..add(card);

    // Update energy
    final newEnergy = _state.player.currentEnergy - card.cost;

    // Handle attack if target selected
    Player newOpponent = _state.opponent;
    if (targetIndex >= 0 && targetIndex < _state.opponent.field.length) {
      newOpponent = _resolveAttack(_state.opponent, targetIndex, card.atk);
    }

    _state = _state.copyWith(
      player: _state.player.copyWith(
        hand: newHand,
        field: newField,
        currentEnergy: newEnergy,
      ),
      opponent: newOpponent,
    );
    notifyListeners();
  }

  Player _resolveAttack(Player victim, int targetIndex, int damage) {
    final targetCard = victim.field[targetIndex];
    final newHp = targetCard.currentHp - damage;

    List<CardModel> newField = List.from(victim.field);

    if (newHp <= 0) {
      // Destroy card
      newField.removeAt(targetIndex);
    } else {
      // Update HP
      newField[targetIndex] = targetCard.copyWith(currentHp: newHp);
    }

    return victim.copyWith(field: newField);
  }

  Future<void> endTurn() async {
    if (_state.phase != GamePhase.play) return;

    // AI Turn
    _state = _state.copyWith(
      phase: GamePhase.combat,
    ); // Using combat phase as "AI thinking"
    notifyListeners();

    await Future.delayed(
      const Duration(milliseconds: 1000),
    ); // Simulate thinking

    _executeAITurn();

    // End Round / Start New Round
    _advanceRound();
  }

  void _executeAITurn() {
    // Simple AI: Play one card if possible
    final (cardToPlay, targetIndex) = _aiService.calculateMove(
      _state.opponent,
      _state.player,
    );

    if (cardToPlay != null) {
      // Remove from hand
      final newHand = List<CardModel>.from(_state.opponent.hand)
        ..remove(cardToPlay);

      // Add to field
      final newField = List<CardModel>.from(_state.opponent.field)
        ..add(cardToPlay);

      // Update energy
      final newEnergy = _state.opponent.currentEnergy - cardToPlay.cost;

      // Handle attack on Player
      Player newPlayer = _state.player;
      if (targetIndex >= 0 && targetIndex < _state.player.field.length) {
        newPlayer = _resolveAttack(_state.player, targetIndex, cardToPlay.atk);
      }

      _state = _state.copyWith(
        opponent: _state.opponent.copyWith(
          hand: newHand,
          field: newField,
          currentEnergy: newEnergy,
        ),
        player: newPlayer,
      );
    }
  }

  void _advanceRound() {
    final nextRound = _state.currentRound + 1;

    if (_turnService.isGameFinished(nextRound)) {
      _determineWinner();
      return;
    }

    final energyGain = _turnService.getEnergyForRound(nextRound);

    // Draw cards for both
    final (pHand, pDeck) = _deckService.drawCards(
      _state.player.hand,
      _state.player.deck,
      1,
    );
    final (oHand, oDeck) = _deckService.drawCards(
      _state.opponent.hand,
      _state.opponent.deck,
      1,
    );

    // Accumulate energy
    final pCurrentEnergy = _state.player.currentEnergy + energyGain;
    final oCurrentEnergy = _state.opponent.currentEnergy + energyGain;

    _state = _state.copyWith(
      currentRound: nextRound,
      phase: GamePhase.play,
      player: _state.player.copyWith(
        hand: pHand,
        deck: pDeck,
        totalEnergy:
            pCurrentEnergy, // Update total to match new current for display
        currentEnergy: pCurrentEnergy,
      ),
      opponent: _state.opponent.copyWith(
        hand: oHand,
        deck: oDeck,
        totalEnergy: oCurrentEnergy,
        currentEnergy: oCurrentEnergy,
      ),
    );
    notifyListeners();
  }

  void _determineWinner() {
    final playerHp = _state.player.totalFieldHp;
    final opponentHp = _state.opponent.totalFieldHp;

    String winner;
    if (playerHp > opponentHp) {
      winner = 'Player';
    } else if (opponentHp > playerHp) {
      winner = 'AI';
    } else {
      winner = 'Draw';
    }

    _state = _state.copyWith(phase: GamePhase.gameOver, winnerId: winner);
    notifyListeners();
  }
}
