import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../flame_components/dev_snap_game.dart';
import '../../services/deck_service.dart';
import '../../services/turn_service.dart';
import '../../services/ai_service.dart';
import '../../viewmodels/game_view_model.dart';
import '../../models/game_state.dart';
import 'game_over_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel(
        deckService: DeckService(),
        turnService: TurnService(),
        aiService: AIService(),
      ),
      child: const _GameScreenContent(),
    );
  }
}

class _GameScreenContent extends StatelessWidget {
  const _GameScreenContent();

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<GameViewModel>(context);

    // Check for Game Over
    if (viewModel.state.phase == GamePhase.gameOver) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) =>
                GameOverScreen(winner: viewModel.state.winnerId ?? 'Draw'),
          ),
        );
      });
    }

    return Scaffold(
      body: Stack(
        children: [
          // Flame Game Layer
          GameWidget(game: DevSnapGame(viewModel: viewModel)),

          // HUD Layer
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Opponent Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPlayerInfo(
                        viewModel.state.opponent,
                        isOpponent: true,
                      ),
                      Text(
                        'Round ${viewModel.state.currentRound}/6',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Player Info & Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildPlayerInfo(
                        viewModel.state.player,
                        isOpponent: false,
                      ),
                      ElevatedButton(
                        onPressed: viewModel.state.phase == GamePhase.play
                            ? () => viewModel.endTurn()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                        ),
                        child: const Text('END TURN'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Phase Indicator (Optional)
          if (viewModel.state.phase == GamePhase.combat)
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                color: Colors.black54,
                child: const Text(
                  'COMBAT PHASE',
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerInfo(player, {required bool isOpponent}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          player.name,
          style: TextStyle(
            color: isOpponent ? Colors.redAccent : Colors.blueAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Energy moved to board
        Text(
          'Power: ${player.totalFieldHp}',
          style: const TextStyle(color: Colors.greenAccent, fontSize: 16),
        ),
      ],
    );
  }
}
