import 'package:flutter/material.dart';

import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dice Game',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: const Color.fromARGB(255, 8, 77, 28)),
      ),
      home: const MyHomePage(title: 'Dice Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int maxRounds = 3; // Rule 1: each player gets three chances

  // Start at 1, not 0: diceNames[dice - 1] needs a valid index on first build.
  int dice1 = 1;
  int dice2 = 1;
  int score1 = 0;
  int score2 = 0;
  int round = 0; // finished rounds (one round = both players rolled once)
  bool player = false; // false = Player 1's turn, true = Player 2's turn
  String winner = '?';
  List<String> diceNames = ['one', 'two', 'three', 'four', 'five', 'six'];

  bool get gameOver => round >= maxRounds;

  void rollPlayer1() {
    if (player || gameOver) return; // not Player 1's turn
    setState(() {
      dice1 = Random().nextInt(6) + 1;
      player = true;
    });
  }

  void rollPlayer2() {
    if (!player || gameOver) return; // not Player 2's turn
    setState(() {
      dice2 = Random().nextInt(6) + 1;
      player = false;

      // Score once per round, only after both players have rolled.
      // Same number on both dice = nobody scores.
      if (dice1 > dice2) {
        score1++;
      } else if (dice2 > dice1) {
        score2++;
      }
      round++;

      if (gameOver) winner = decideWinner();
    });
  }

  // Rule 2: the player with the higher score wins.
  String decideWinner() {
    if (score1 > score2) return 'Player 1';
    if (score2 > score1) return 'Player 2';
    return 'Draw';
  }

  // Rule 3: Start Game restarts the whole game.
  void restartGame() {
    setState(() {
      dice1 = Random().nextInt(6) + 1;
      dice2 = Random().nextInt(6) + 1;
      score1 = 0;
      score2 = 0;
      round = 0;
      player = false;
      winner = '?';
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by rollPlayer1, rollPlayer2 and restartGame above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    TextStyle ruleStyle = TextStyle(color: Colors.grey, fontSize: 14);
    String status = gameOver
        ? "Game over - press Start Game to play again"
        : "Round ${round + 1} of $maxRounds - ${player ? 'Player 2' : 'Player 1'}'s turn";
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.green,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(
          "Dice Games ",
          style: TextStyle(
            fontSize: 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 5,
        shadowColor: const Color.fromARGB(255, 88, 98, 112),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Column(
            children: [
              Text(
                "Winner : $winner",
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(status, style: ruleStyle),
              SizedBox(height: 30),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              Column(
                children: [
                  Text(
                    "Player 1",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: rollPlayer1,
                    child: Image.asset(
                      'assets/images/${diceNames[dice1 - 1]}.jpg',
                      width: 120,
                    ),
                  ),
                  Text("$dice1"),
                  Text(
                    "Score : $score1",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "Player 2",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: rollPlayer2,
                    child: Image.asset(
                      'assets/images/${diceNames[dice2 - 1]}.jpg',
                      width: 120,
                    ),
                  ),
                  Text("$dice2"),
                  Text(
                    "Score : $score2",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: restartGame,
                child: Container(
                  width: 115,
                  height: 55,
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center, // puts the text in the middle
                  decoration: BoxDecoration(
                    color: Colors.green, // button background
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Start Game",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 100),
              Text(
                "Game Rules",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "1. Each player get three chance to shuffle the dice.",
                style: ruleStyle,
              ),
              Text(
                "2. The Player with higher score will win the game.",
                style: ruleStyle,
              ),
              Text(
                "3. The button Start Game will restart the game .",
                style: ruleStyle,
              ),
            ],
          ),

          Column(
            children: [
              SizedBox(height: 40),
              Image.asset(
                'assets/images/diceFive.jpg',
                width: 180,
                fit: BoxFit.contain,
              ),
              Text("Created with (-_-) by Himmat.", style: ruleStyle),
            ],
          ),
        ],
      ),
    );
  }
}
