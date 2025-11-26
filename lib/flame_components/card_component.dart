import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../models/card_model.dart';

class CardComponent extends PositionComponent with DragCallbacks, HasGameRef {
  final CardModel card;
  final bool isPlayerCard;
  final bool isDraggable;
  final Function(CardComponent) onDragStartCallback;
  final Function(CardComponent, Vector2) onDragUpdateCallback;
  final Function(CardComponent) onDragEndCallback;

  final bool isFaceUp;

  CardComponent({
    required this.card,
    required this.isPlayerCard,
    this.isDraggable = false,
    this.isFaceUp = true,
    required this.onDragStartCallback,
    required this.onDragUpdateCallback,
    required this.onDragEndCallback,
  }) : super(size: Vector2(100, 140)); // Standard card size

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load appropriate sprite
    final String imagePath = isFaceUp
        ? card.assetPath
        : 'card_default_back.png';

    // Background (Sprite)
    try {
      final sprite = await gameRef.loadSprite(imagePath);
      add(SpriteComponent(sprite: sprite, size: size));
    } catch (e) {
      // Fallback if image fails
      add(
        RectangleComponent(
          size: size,
          paint: Paint()
            ..color = isFaceUp
                ? (isPlayerCard ? Colors.blueGrey : Colors.redAccent)
                : Colors.brown,
        ),
      );
    }

    // Only show text details if face up
    if (isFaceUp) {
      // Text overlays removed as requested since images already contain them.
      // We can keep the name for accessibility or debugging if needed, but user asked to remove info.
      // Let's remove all visible text overlays.
    }
  }

  void setHighlighted(bool highlighted) {
    if (highlighted) {
      scale = Vector2.all(1.2); // Scale up when highlighted
      // Optional: Add a glow effect or border if desired, but scale is a clear indicator
    } else {
      scale = Vector2.all(1.0);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    if (!isDraggable) return;
    super.onDragStart(event);
    priority = 100; // Bring to front
    onDragStartCallback(this);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (!isDraggable) return;
    position += event.localDelta;
    onDragUpdateCallback(this, position);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (!isDraggable) return;
    super.onDragEnd(event);
    priority = 0; // Reset priority
    onDragEndCallback(this);
  }
}
