import 'package:flame/game.dart';
import '../viewmodels/game_view_model.dart';
import 'board_component.dart';

class DevSnapGame extends FlameGame {
  final GameViewModel viewModel;

  DevSnapGame({required this.viewModel});

  late BoardComponent board;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Add board
    board = BoardComponent(viewModel: viewModel);
    add(board);

    // Listen to ViewModel changes to update game state
    viewModel.addListener(_onGameStateChanged);
  }

  void _onGameStateChanged() {
    // Here we can trigger animations or updates based on state changes
    // For example, if a card is played, we might want to animate it
    // But for now, the components will mostly react to the state themselves via update() or by rebuilding
    // Actually, in Flame, we usually want components to be reactive.
    // Let's pass the state down or have components listen.
    // BoardComponent will handle distributing cards.
    board.updateState();
  }

  @override
  void onRemove() {
    viewModel.removeListener(_onGameStateChanged);
    super.onRemove();
  }
}
