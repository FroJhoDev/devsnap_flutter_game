import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../viewmodels/game_view_model.dart';
import '../models/card_model.dart';
import 'card_component.dart';

class BoardComponent extends PositionComponent with HasGameRef {
  final GameViewModel viewModel;

  BoardComponent({required this.viewModel});

  late PositionComponent playerHandZone;
  late PositionComponent playerFieldZone;
  late PositionComponent opponentFieldZone;
  late PositionComponent opponentHandZone; // Visual only, maybe face down

  late TextComponent energyText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = Vector2(
      400,
      800,
    ); // Assuming a fixed aspect ratio for now, will scale in GameWidget

    // Board Background
    try {
      final sprite = await gameRef.loadSprite('board_background.png');
      add(
        SpriteComponent(
          sprite: sprite,
          size: size,
          priority: -10, // Ensure it's behind everything
        ),
      );
    } catch (e) {
      // Fallback
      add(
        RectangleComponent(size: size, paint: Paint()..color = Colors.black87),
      );
    }

    // Zones
    opponentHandZone = PositionComponent(
      position: Vector2(0, 0),
      size: Vector2(400, 150),
    );
    opponentFieldZone = PositionComponent(
      position: Vector2(0, 150),
      size: Vector2(400, 200),
    );
    playerFieldZone = PositionComponent(
      position: Vector2(0, 350),
      size: Vector2(400, 200),
    );

    // Player Hand Zone - Lowered and Centered
    // 20px from bottom (800 - 20 = 780 bottom edge).
    // Height is ~140 (card height). Top at 780 - 140 = 640.
    playerHandZone = PositionComponent(
      position: Vector2(0, 640),
      size: Vector2(400, 140),
    );

    add(opponentHandZone);
    add(opponentFieldZone);
    add(playerFieldZone);
    add(playerHandZone);

    // Energy Display - Centered above player hand
    energyText = TextComponent(
      text: '0',
      textRenderer: TextPaint(
        style: const TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.bold,
          color: Colors.cyanAccent,
          shadows: [
            Shadow(blurRadius: 10, color: Colors.blue, offset: Offset(0, 0)),
          ],
        ),
      ),
    );
    // Center horizontally, place slightly above hand (y=640)
    energyText.anchor = Anchor.center;
    energyText.position = Vector2(200, 600);
    add(energyText);

    updateState();
  }

  void updateState() {
    // Update Energy
    energyText.text = '${viewModel.state.player.currentEnergy}';

    // Clear existing cards
    playerHandZone.removeAll(playerHandZone.children);
    playerFieldZone.removeAll(playerFieldZone.children);
    opponentFieldZone.removeAll(opponentFieldZone.children);
    opponentHandZone.removeAll(opponentHandZone.children);

    // Render Player Hand (Centered)
    _renderHandCards(
      viewModel.state.player.hand,
      playerHandZone,
      isPlayer: true,
    );

    // Render Player Field
    _renderCards(
      viewModel.state.player.field,
      playerFieldZone,
      isPlayer: true,
      isHand: false,
      isFaceUp: true,
    );

    // Render Opponent Field
    _renderCards(
      viewModel.state.opponent.field,
      opponentFieldZone,
      isPlayer: false,
      isHand: false,
      isFaceUp: true,
    );

    // Render Opponent Hand (Face Down)
    _renderCards(
      viewModel.state.opponent.hand,
      opponentHandZone,
      isPlayer: false,
      isHand: true,
      isFaceUp: false,
    );
  }

  void _renderHandCards(
    List<CardModel> cards,
    PositionComponent zone, {
    required bool isPlayer,
  }) {
    if (cards.isEmpty) return;

    final cardWidth = 100.0;
    final spacing = 10.0;
    final totalWidth =
        (cards.length * cardWidth) + ((cards.length - 1) * spacing);
    double startX = (zone.size.x - totalWidth) / 2;

    // Ensure startX is not negative (if too many cards)
    if (startX < 10) startX = 10;

    double xOffset = startX;

    for (final card in cards) {
      final cardComp = CardComponent(
        card: card,
        isPlayerCard: isPlayer,
        isDraggable: isPlayer,
        isFaceUp: true,
        onDragStartCallback: (c) {},
        onDragUpdateCallback: (c, pos) => _handleDragUpdate(c),
        onDragEndCallback: (c) => _handleCardDrop(c, zone),
      );

      cardComp.position = Vector2(xOffset, 0); // y=0 relative to zone
      zone.add(cardComp);
      xOffset += cardWidth + spacing;
    }
  }

  void _renderCards(
    List<CardModel> cards,
    PositionComponent zone, {
    required bool isPlayer,
    required bool isHand,
    required bool isFaceUp,
  }) {
    double xOffset = 10;
    double yOffset = 10;

    for (final card in cards) {
      final cardComp = CardComponent(
        card: card,
        isPlayerCard: isPlayer,
        isDraggable: isPlayer && isHand, // Only player hand cards are draggable
        isFaceUp: isFaceUp,
        onDragStartCallback: (c) {},
        onDragUpdateCallback:
            (c, pos) {}, // No highlight logic needed for non-draggable cards
        onDragEndCallback: (c) => _handleCardDrop(c, zone),
      );

      // Resize if on field to fit more cards
      if (!isHand) {
        cardComp.size = Vector2(70, 98); // 70% of original 100x140
      }

      cardComp.position = Vector2(xOffset, yOffset);
      zone.add(cardComp);

      // Adjust spacing based on size
      double spacing = isHand ? 110 : 80;
      xOffset += spacing;

      if (xOffset > 350) {
        // Wrap sooner if needed, or just let them overflow/scroll (scrolling not impl yet)
        xOffset = 10;
        yOffset += isHand ? 150 : 110;
      }
    }
  }

  void _handleDragUpdate(CardComponent cardComp) {
    // Check for overlap with enemy cards to highlight
    final cardGlobalPos = cardComp.absolutePosition;
    final cardRect = Rect.fromLTWH(
      cardGlobalPos.x,
      cardGlobalPos.y,
      cardComp.size.x,
      cardComp.size.y,
    );

    for (final child in opponentFieldZone.children) {
      if (child is CardComponent) {
        final enemyRect = Rect.fromLTWH(
          child.absolutePosition.x,
          child.absolutePosition.y,
          child.size.x,
          child.size.y,
        );

        if (cardRect.overlaps(enemyRect)) {
          child.setHighlighted(true);
        } else {
          child.setHighlighted(false);
        }
      }
    }
  }

  void _handleCardDrop(CardComponent cardComp, PositionComponent sourceZone) {
    // Reset highlights
    for (final child in opponentFieldZone.children) {
      if (child is CardComponent) {
        child.setHighlighted(false);
      }
    }

    final cardGlobalPos = cardComp.absolutePosition;
    final cardRect = Rect.fromLTWH(
      cardGlobalPos.x,
      cardGlobalPos.y,
      cardComp.size.x,
      cardComp.size.y,
    );

    // 1. Check if dropped on an enemy card (Attack)
    int targetIndex = -1;
    for (int i = 0; i < opponentFieldZone.children.length; i++) {
      final enemyCard = opponentFieldZone.children.toList()[i] as CardComponent;
      final enemyRect = Rect.fromLTWH(
        enemyCard.absolutePosition.x,
        enemyCard.absolutePosition.y,
        enemyCard.size.x,
        enemyCard.size.y,
      );

      if (cardRect.overlaps(enemyRect)) {
        targetIndex = i;
        break;
      }
    }

    // 2. Check if dropped in player field zone (Play without target)
    final fieldGlobalPos = playerFieldZone.absolutePosition;
    final fieldSize = playerFieldZone.size;
    final fieldRect = Rect.fromLTWH(
      fieldGlobalPos.x,
      fieldGlobalPos.y,
      fieldSize.x,
      fieldSize.y,
    );

    bool droppedInField = fieldRect.overlaps(cardRect);

    // Execute Play if valid
    if (targetIndex != -1 || droppedInField) {
      if (viewModel.state.player.currentEnergy >= cardComp.card.cost) {
        viewModel.playCard(cardComp.card, targetIndex: targetIndex);
        // The card will be moved to the field automatically when updateState() is called by the listener
      } else {
        // Not enough energy
        updateState();
      }
    } else {
      // Invalid drop
      updateState();
    }
  }
}
