import 'dart:math';
import 'package:dejapew/common/enums/difficulty_level.dart';
import 'package:dejapew/common/shared_models/game_card.dart';

class ComputerAgent {
  bool isPlaying;
  DifficultyLevel level;
  List<GameCard> memory;

  late int _memoryLength;

  ComputerAgent({
    this.level = DifficultyLevel.normal,
    required this.memory,
    this.isPlaying = false,
  }) {
    _memoryLength = level == DifficultyLevel.easy
        ? 6
        : level == DifficultyLevel.normal
        ? 12
        : 16;
  }

  bool get hasSufficientCards => memory.length == _memoryLength;

  void memorizeCard(GameCard card) {
    if (!memory.any((e) => e.id == card.id)) {
      if (memory.length >= _memoryLength) {
        memory.removeWhere(
          (e) => memory.where((x) => x.path == e.path).length == 1,
        );
      }
      memory.add(card);
    }
  }

  List<GameCard> chooseCardsFromMemory() {
    if (memory.isEmpty) return [];

    List<GameCard> cards = [];
    for (final item in memory) {
      if (memory.any((e) => e.id != item.id && item.path == e.path)) {
        final dup = memory.firstWhere((e) => e.path == item.path);
        cards = <GameCard>[item, dup];
      }
    }

    double probability;
    switch (level) {
      case DifficultyLevel.easy:
        probability = 0.33;
        break;
      case DifficultyLevel.normal:
        probability = 0.66;
        break;
      case DifficultyLevel.hard:
        probability = 0.99;
        break;
    }

    final rng = Random(); // random double between 0.0 and 1.0
    if (rng.nextDouble() > probability) {
      var card_1 = memory[rng.nextInt(memory.length)];
      var card_2 = memory[rng.nextInt(memory.length)];
      while (card_2.id == card_1.id) {
        card_2 = memory[rng.nextInt(memory.length)];
      }
      cards = <GameCard>[card_1, card_2];
    }

    memory.removeWhere((e) => e.id == cards[0].id || e.id == cards[1].id);
    return cards;
  }
}
