import 'package:card_game_new/app/data.dart';
import 'package:get/get.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class GameController extends GetxController {
  final Level level;
  GameController(this.level);

  var previousIndex = (-1).obs;
  var flip = false.obs;
  var start = false.obs;
  var wait = false.obs;
  var time = 0.obs;
  var left = 0.obs;
  var isFinished = false.obs;
  var score = 0.obs;
  List<String> data = [];
  List<bool> cardFlips = [];
  List<GlobalKey<FlipCardState>> cardStateKeys = [];
  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    restart();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void startMemoryTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      time.value -= 1;
      if (time.value <= 0) {
        timer?.cancel();
        start.value = true;
        startPlayTimer();
      }
    });
  }

  void startPlayTimer() {
    int playTime = 10;
    if (level == Level.Medium) {
      playTime = 15;
    } else if (level == Level.Hard) {
      playTime = 20;
    }

    time.value = playTime;
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      time.value -= 1;
      if (time.value <= 0) {
        timer?.cancel();
        isFinished.value = true;
      }
    });
  }

  void restart() {
    data = getSourceArray(level);
    cardFlips = getInitialItemState(level);
    cardStateKeys = getCardStateKeys(level);
    score.value = 0;

    int memoryTime = 5;
    if (level == Level.Medium) {
      memoryTime = 10;
    } else if (level == Level.Hard) {
      memoryTime = 15;
    }

    time.value = memoryTime;
    left.value = (data.length ~/ 2);
    isFinished.value = false;
    startMemoryTimer();
  }

  void onFlip(int index) {
    if (!flip.value) {
      flip.value = true;
      previousIndex.value = index;
    } else {
      flip.value = false;
      if (previousIndex.value != index) {
        if (data[previousIndex.value] != data[index]) {
          wait.value = true;
          Future.delayed(const Duration(milliseconds: 1500), () {
            cardStateKeys[previousIndex.value].currentState?.toggleCard();
            previousIndex.value = index;
            cardStateKeys[previousIndex.value].currentState?.toggleCard();
            Future.delayed(const Duration(milliseconds: 160), () {
              wait.value = false;
            });
          });
        } else {
          cardFlips[previousIndex.value] = false;
          cardFlips[index] = false;
          score.value += 10;
          left.value -= 1;
          if (cardFlips.every((t) => t == false)) {
            Future.delayed(const Duration(milliseconds: 160), () {
              isFinished.value = true;
              start.value = false;
            });
          }
        }
      }
    }
  }

  Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            blurRadius: 3,
            spreadRadius: 0.8,
            offset: Offset(2.0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.all(4.0),
      child: Image.asset(data[index]),
    );
  }
}
