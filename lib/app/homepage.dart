import 'package:flutter/material.dart';
import 'flipcardgame.dart';
import 'data.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _list.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => _list[index].goto,
                    ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: _list[index].primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 4,
                                color: Colors.black45,
                                spreadRadius: 0.5,
                                offset: Offset(3, 4))
                          ]),
                    ),
                    Container(
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: _list[index].secondaryColor ?? Colors.grey,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                                blurRadius: 4,
                                color: Colors.black12,
                                spreadRadius: 0.3,
                                offset: Offset(
                                  5,
                                  3,
                                ))
                          ]),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                              child: Text(
                            _list[index].name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black26,
                                    blurRadius: 2,
                                    offset: Offset(1, 2),
                                  ),
                                  Shadow(
                                      color: Colors.green,
                                      blurRadius: 2,
                                      offset: Offset(0.5, 2))
                                ]),
                          )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: generateStars(_list[index].noOfStars),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  List<Widget> generateStars(int no) {
    List<Widget> _icons = [];
    for (int i = 0; i < no; i++) {
      _icons.add(
          const Icon(
            Icons.star,
            color: Colors.yellow,
          ));
    }
    return _icons;
  }
}

class Details {
  String name;
  Color primaryColor;
  Color? secondaryColor;
  Widget goto;
  int noOfStars;

  Details(
      {required this.name,
      required this.primaryColor,
      this.secondaryColor,
      required this.noOfStars,
      required this.goto});
}

List<Details> _list = [
  Details(
      name: "EASY",
      primaryColor: Colors.green,
      secondaryColor: Colors.green[300],
      noOfStars: 1,
      goto: FlipCardGame(Level.Easy)),
  Details(
      name: "MEDIUM",
      primaryColor: Colors.orange,
      secondaryColor: Colors.orange[300],
      noOfStars: 2,
      goto: FlipCardGame(Level.Medium)),
  Details(
      name: "HARD",
      primaryColor: Colors.red,
      secondaryColor: Colors.red[300],
      noOfStars: 3,
      goto: FlipCardGame(Level.Hard))
];
