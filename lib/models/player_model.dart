import 'package:equatable/equatable.dart';
import 'card_model.dart';

class Player extends Equatable {
  final String id;
  final String name;
  final List<CardModel> deck;
  final List<CardModel> hand;
  final List<CardModel> field;
  final int totalEnergy; // Energy available for the turn
  final int currentEnergy; // Energy remaining to spend

  const Player({
    required this.id,
    required this.name,
    this.deck = const [],
    this.hand = const [],
    this.field = const [],
    this.totalEnergy = 0,
    this.currentEnergy = 0,
  });

  Player copyWith({
    String? id,
    String? name,
    List<CardModel>? deck,
    List<CardModel>? hand,
    List<CardModel>? field,
    int? totalEnergy,
    int? currentEnergy,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      deck: deck ?? this.deck,
      hand: hand ?? this.hand,
      field: field ?? this.field,
      totalEnergy: totalEnergy ?? this.totalEnergy,
      currentEnergy: currentEnergy ?? this.currentEnergy,
    );
  }

  int get totalFieldHp => field.fold(0, (sum, card) => sum + card.currentHp);

  @override
  List<Object?> get props => [
    id,
    name,
    deck,
    hand,
    field,
    totalEnergy,
    currentEnergy,
  ];
}
