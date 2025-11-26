// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CardModel _$CardModelFromJson(Map<String, dynamic> json) => CardModel(
  id: json['id'] as String,
  name: json['name'] as String,
  cost: (json['cost'] as num).toInt(),
  hp: (json['hp'] as num).toInt(),
  atk: (json['atk'] as num).toInt(),
  flavor: json['flavor'] as String,
  assetPath: json['assetPath'] as String,
);

Map<String, dynamic> _$CardModelToJson(CardModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'cost': instance.cost,
  'hp': instance.hp,
  'atk': instance.atk,
  'flavor': instance.flavor,
  'assetPath': instance.assetPath,
};
