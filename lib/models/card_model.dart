import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'card_model.g.dart';

@JsonSerializable()
class CardModel extends Equatable {
  final String id;
  final String name;
  final int cost;
  final int hp;
  final int atk;
  final String flavor;
  final String assetPath;

  // Mutable state for gameplay (current HP might change)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final int currentHp;

  const CardModel({
    required this.id,
    required this.name,
    required this.cost,
    required this.hp,
    required this.atk,
    required this.flavor,
    required this.assetPath,
    int? currentHp,
  }) : currentHp = currentHp ?? hp;

  CardModel copyWith({
    String? id,
    String? name,
    int? cost,
    int? hp,
    int? atk,
    String? flavor,
    String? assetPath,
    int? currentHp,
  }) {
    return CardModel(
      id: id ?? this.id,
      name: name ?? this.name,
      cost: cost ?? this.cost,
      hp: hp ?? this.hp,
      atk: atk ?? this.atk,
      flavor: flavor ?? this.flavor,
      assetPath: assetPath ?? this.assetPath,
      currentHp: currentHp ?? this.currentHp,
    );
  }

  bool get isDead => currentHp <= 0;

  factory CardModel.fromJson(Map<String, dynamic> json) =>
      _$CardModelFromJson(json);
  Map<String, dynamic> toJson() => _$CardModelToJson(this);

  @override
  List<Object?> get props => [
    id,
    name,
    cost,
    hp,
    atk,
    flavor,
    assetPath,
    currentHp,
  ];
}
