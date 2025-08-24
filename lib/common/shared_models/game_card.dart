import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class GameCard {
  String id = '';
  String path;
  FlipCardController? controller;
  Key? key;
  bool keepValue = false;
  GameCard(this.path);

  bool isMatch(String id) {
    if (id == this.id) {
      return true;
    }
    return false;
  }
}
