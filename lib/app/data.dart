import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

enum Level { Hard, Medium, Easy }

List<String> fillSourceArray() {
  return [
    'assets/animalspics/dino.png',
    'assets/animalspics/dino.png',
    'assets/animalspics/wolf.png',
    'assets/animalspics/wolf.png',
    'assets/animalspics/peacock.png',
    'assets/animalspics/peacock.png',
    'assets/animalspics/whale.png',
    'assets/animalspics/whale.png',
    'assets/animalspics/octo.png',
    'assets/animalspics/octo.png',
    'assets/animalspics/fish.png',
    'assets/animalspics/fish.png',
    'assets/animalspics/frog.png',
    'assets/animalspics/frog.png',
    'assets/animalspics/seahorse.png',
    'assets/animalspics/seahorse.png',
    'assets/animalspics/girraf.png',
    'assets/animalspics/girraf.png',
  ];
}

List<String> getSourceArray(Level level) {
  List<String> levelAndKindList = [];
  List<String> sourceArray = fillSourceArray();
  if (level == Level.Hard) {
    levelAndKindList.addAll(sourceArray);
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      levelAndKindList.add(sourceArray[i]);
    }
  }

  levelAndKindList.shuffle();
  return levelAndKindList;
}

List<bool> getInitialItemState(Level level) {
  List<bool> initialItemState = [];
  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      initialItemState.add(true);
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      initialItemState.add(true);
    }
  }
  return initialItemState;
}

List<GlobalKey<FlipCardState>> getCardStateKeys(Level level) {
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  if (level == Level.Hard) {
    for (int i = 0; i < 18; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.Medium) {
    for (int i = 0; i < 12; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  } else if (level == Level.Easy) {
    for (int i = 0; i < 6; i++) {
      cardStateKeys.add(GlobalKey<FlipCardState>());
    }
  }
  return cardStateKeys;
}
