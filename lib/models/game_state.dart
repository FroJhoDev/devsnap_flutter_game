import 'package:equatable/equatable.dart';
import 'player_model.dart';

enum GamePhase { draw, play, combat, endTurn, gameOver }

class GameState extends Equatable {
  final Player player;
  final Player opponent;
  final int currentRound;
  final GamePhase phase;
  final String? winnerId;

  const GameState({
    required this.player,
    required this.opponent,
    this.currentRound = 1,
    this.phase = GamePhase.draw,
    this.winnerId,
  });

  GameState copyWith({
    Player? player,
    Player? opponent,
    int? currentRound,
    GamePhase? phase,
    String? winnerId,
  }) {
    return GameState(
      player: player ?? this.player,
      opponent: opponent ?? this.opponent,
      currentRound: currentRound ?? this.currentRound,
      phase: phase ?? this.phase,
      winnerId: winnerId ?? this.winnerId,
    );
  }

  bool get isGameOver => phase == GamePhase.gameOver;

  @override
  List<Object?> get props => [player, opponent, currentRound, phase, winnerId];
}
