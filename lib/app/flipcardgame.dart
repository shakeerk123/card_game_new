import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'data.dart';
import 'dart:async';

class FlipCardGame extends StatefulWidget {
  final Level level;
  FlipCardGame(this.level);
  @override
  _FlipCardGameState createState() => _FlipCardGameState(level);
}

class _FlipCardGameState extends State<FlipCardGame> {
  _FlipCardGameState(this.level);

  int _previousIndex = -1;
  bool _flip = false;
  bool _start = false;
  bool _wait = false;
  Level level;
  Timer? _timer;
  int _time = 0;
  int _totalTime = 0;
  int _left = 0;
  bool _isFinished = false;
  List<String> _data = [];

  List<bool> _cardFlips = [];
  List<GlobalKey<FlipCardState>> _cardStateKeys = [];

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
      child: Image.asset(_data[index]),
    );
  }

  void startMemoryTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _time -= 1;
        if (_time <= 0) {
          _timer?.cancel();
          _start = true;
          startPlayTimer();
        }
      });
    });
  }

  void startPlayTimer() {
    int playTime = 10;
    if (level == Level.Medium) {
      playTime = 20;
    } else if (level == Level.Hard) {
      playTime = 30;
    }

    _time = playTime;
    _totalTime = playTime;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        _time -= 1;
        if (_time <= 0) {
          _timer?.cancel();
          _isFinished = true;
        }
      });
    });
  }

  void restart() {
    setState(() {
      _data = getSourceArray(level);
      _cardFlips = getInitialItemState(level);
      _cardStateKeys = getCardStateKeys(level);

      // Set the memory time based on the level
      int memoryTime = 5;
      if (level == Level.Medium) {
        memoryTime = 8;
      } else if (level == Level.Hard) {
        memoryTime = 10;
      }

      _time = memoryTime;
      _totalTime = memoryTime;
      _left = (_data.length ~/ 2);
      _isFinished = false;
      startMemoryTimer();
    });
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isFinished
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _left == 0 ? 'You Win!' : 'You Lose!',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          restart();
                        });
                      },
                      child: const Text("Play Again"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Go Back to Home"),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          LinearProgressIndicator(
                            value: (_totalTime - _time) / _totalTime,
                            minHeight: 10,
                          ),
                          const SizedBox(height: 8),
                          _time > 0
                              ? Text(
                                  '$_time',
                                  style: Theme.of(context).textTheme.headlineLarge,
                                )
                              : Text(
                                  'Left: $_left',
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemBuilder: (context, index) => _start
                            ? FlipCard(
                                key: _cardStateKeys[index],
                                onFlip: () {
                                  if (!_flip) {
                                    _flip = true;
                                    _previousIndex = index;
                                  } else {
                                    _flip = false;
                                    if (_previousIndex != index) {
                                      if (_data[_previousIndex] !=
                                          _data[index]) {
                                        _wait = true;
                                        Future.delayed(
                                            const Duration(milliseconds: 1500),
                                            () {
                                          _cardStateKeys[_previousIndex]
                                              .currentState
                                              ?.toggleCard();
                                          _previousIndex = index;
                                          _cardStateKeys[_previousIndex]
                                              .currentState
                                              ?.toggleCard();

                                          Future.delayed(
                                              const Duration(milliseconds: 160),
                                              () {
                                            setState(() {
                                              _wait = false;
                                            });
                                          });
                                        });
                                      } else {
                                        _cardFlips[_previousIndex] = false;
                                        _cardFlips[index] = false;
                                        setState(() {
                                          _left -= 1;
                                        });
                                        if (_cardFlips
                                            .every((t) => t == false)) {
                                          Future.delayed(
                                              const Duration(milliseconds: 160),
                                              () {
                                            setState(() {
                                              _isFinished = true;
                                              _start = false;
                                            });
                                          });
                                        }
                                      }
                                    }
                                  }
                                  setState(() {});
                                },
                                flipOnTouch: _wait ? false : _cardFlips[index],
                                direction: FlipDirection.HORIZONTAL,
                                front: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(5),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black45,
                                        blurRadius: 3,
                                        spreadRadius: 0.8,
                                        offset: Offset(2.0, 1),
                                      )
                                    ],
                                  ),
                                  margin: const EdgeInsets.all(4.0),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      "assets/animalspics/quest.png",
                                    ),
                                  ),
                                ),
                                back: getItem(index),
                              )
                            : getItem(index),
                        itemCount: _data.length,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
