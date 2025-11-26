import 'package:uuid/uuid.dart';
import '../models/card_model.dart';

class DeckService {
  final Uuid _uuid = const Uuid();

  List<CardModel> getInitialDeck() {
    final List<Map<String, dynamic>> rawCards = [
      {
        'name': 'Flutter',
        'cost': 3,
        'hp': 4,
        'atk': 2,
        'flavor': 'UI Avenger',
        'assetPath': 'flutter_card_front.png',
      },

      // Let me re-check the list.
      // angular_card_front.png
      // board_background.png
      // c#_card_front.png
      // card_default_back.png
      // flutter_card_front.png
      // go_card_front.png
      // java_card_front.png
      // javascript_card_front.png
      // kotlin_card_front.png
      // php_card_front.png
      // python_card_front.png
      // react_card_front.png
      // ruby_card_front.png
      // sql_card_front.png
      // swift_card_front.png
      // typescript_card_front.png

      // Missing from file list but in deck: Dart.
      // I will assume it might be missing or named differently?
      // Actually, looking at the list, 'dart' is NOT there. 'flutter' is there.
      // I will use a placeholder or one of the others for now if missing, or maybe I missed it.
      // Let's look at the list again carefully.
      // angular, c#, flutter, go, java, javascript, kotlin, php, python, react, ruby, sql, swift, typescript.
      // Total 14 card fronts.
      // Deck has 15 cards.
      // Missing: Dart.
      // I'll use flutter_card_front.png for Dart as well for now or just leave it as 'dart.png' and it will fail to load, showing white.
      // Better: Use flutter_card_front.png for Dart as a fallback.
      {
        'name': 'Dart',
        'cost': 2,
        'hp': 3,
        'atk': 2,
        'flavor': 'Speedster',
        'assetPath': 'flutter_card_front.png',
      }, // Fallback
      {
        'name': 'PHP',
        'cost': 1,
        'hp': 2,
        'atk': 1,
        'flavor': 'Old Guard',
        'assetPath': 'php_card_front.png',
      },
      {
        'name': 'JavaScript',
        'cost': 2,
        'hp': 2,
        'atk': 2,
        'flavor': 'Wildcard',
        'assetPath': 'javascript_card_front.png',
      },
      {
        'name': 'Java',
        'cost': 4,
        'hp': 5,
        'atk': 3,
        'flavor': 'The Tank',
        'assetPath': 'java_card_front.png',
      },
      {
        'name': 'Python',
        'cost': 3,
        'hp': 3,
        'atk': 3,
        'flavor': 'Sage',
        'assetPath': 'python_card_front.png',
      },
      {
        'name': 'React',
        'cost': 3,
        'hp': 4,
        'atk': 2,
        'flavor': 'Component Hero',
        'assetPath': 'react_card_front.png',
      },
      {
        'name': 'Angular',
        'cost': 4,
        'hp': 5,
        'atk': 2,
        'flavor': 'Framework Fortress',
        'assetPath': 'angular_card_front.png',
      },
      {
        'name': 'C#',
        'cost': 3,
        'hp': 4,
        'atk': 2,
        'flavor': 'Versatile Knight',
        'assetPath': 'c#_card_front.png',
      },
      {
        'name': 'TypeScript',
        'cost': 2,
        'hp': 3,
        'atk': 2,
        'flavor': 'Typed Blade',
        'assetPath': 'typescript_card_front.png',
      },
      {
        'name': 'SQL',
        'cost': 1,
        'hp': 3,
        'atk': 1,
        'flavor': 'Data Sentinel',
        'assetPath': 'sql_card_front.png',
      },
      {
        'name': 'Go',
        'cost': 2,
        'hp': 3,
        'atk': 2,
        'flavor': 'Concurrency Runner',
        'assetPath': 'go_card_front.png',
      },
      {
        'name': 'Kotlin',
        'cost': 3,
        'hp': 3,
        'atk': 3,
        'flavor': 'Modern Samurai',
        'assetPath': 'kotlin_card_front.png',
      },
      {
        'name': 'Swift',
        'cost': 3,
        'hp': 3,
        'atk': 3,
        'flavor': 'iOS Ranger',
        'assetPath': 'swift_card_front.png',
      },
      {
        'name': 'Ruby',
        'cost': 2,
        'hp': 2,
        'atk': 2,
        'flavor': 'Crystal Coder',
        'assetPath': 'ruby_card_front.png',
      },
    ];

    return rawCards.map((data) {
      return CardModel(
        id: _uuid.v4(),
        name: data['name'],
        cost: data['cost'],
        hp: data['hp'],
        atk: data['atk'],
        flavor: data['flavor'],
        assetPath: data['assetPath'],
      );
    }).toList();
  }

  List<CardModel> shuffleDeck(List<CardModel> deck) {
    final shuffled = List<CardModel>.from(deck);
    shuffled.shuffle();
    return shuffled;
  }

  (List<CardModel> hand, List<CardModel> deck) drawCards(
    List<CardModel> currentHand,
    List<CardModel> currentDeck,
    int count,
  ) {
    final newHand = List<CardModel>.from(currentHand);
    final newDeck = List<CardModel>.from(currentDeck);

    for (int i = 0; i < count; i++) {
      if (newDeck.isNotEmpty) {
        newHand.add(newDeck.removeAt(0));
      }
    }

    return (newHand, newDeck);
  }
}
