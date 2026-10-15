// "dart:async" gives us Timer (to run code again and again after a delay).
// "dart:math" gives us Random (to pick random numbers).
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

// The app starts running from here.
void main() {
  runApp(const MyApp());
}

// MyApp is the root of the app. It only sets up the basic app settings.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // hides the "DEBUG" banner
      home: DiceGame(),                  // the first screen of our app
    );
  }
}

// DiceGame is a StatefulWidget because its data (dice numbers) CHANGES.
// When data changes, the screen must redraw.
class DiceGame extends StatefulWidget {
  const DiceGame({super.key});

  @override
  State<DiceGame> createState() => _DiceGameState();
}

// All the variables and logic of our game live in this State class.
class _DiceGameState extends State<DiceGame> {
  // ---------------- VARIABLES ----------------

  // Current number on each dice (1 to 6).
  int dice1 = 1;
  int dice2 = 1;

  // Becomes true when that player's dice has finished rolling.
  bool done1 = false;
  bool done2 = false;

  // Timers that make the dice "roll". null means "not rolling yet".
  Timer? timer1;
  Timer? timer2;

  // Random number generator.
  Random random = Random();

  // ---------------- FUNCTIONS ----------------

  // Turns a number into an image path.
  // Example: 3 -> "assets/images/three.jpg"
  String getImage(int number) {
    List<String> names = ['one', 'two', 'three', 'four', 'five', 'six'];
    // Lists start at index 0, so number 1 is at index 0.
    return 'assets/images/${names[number - 1]}.jpg';
  }

  // Rolls Player 1's dice.
  void rollDice1() {
    // If a timer already exists, this dice was already tapped. Do nothing.
    if (timer1 != null) return;

    int count = 0; // how many times the dice face has changed

    // Run the code inside every 80 milliseconds.
    timer1 = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      count = count + 1;

      // setState tells Flutter: "data changed, please redraw the screen".
      setState(() {
        dice1 = random.nextInt(6) + 1; // nextInt(6) gives 0-5, so +1 gives 1-6
      });

      // After 12 changes (about 1 second), stop rolling.
      if (count == 12) {
        timer.cancel(); // stop the timer
        setState(() {
          done1 = true; // the last number shown is the final result
        });
      }
    });
  }

  // Rolls Player 2's dice. Same steps as rollDice1, but for dice2.
  void rollDice2() {
    if (timer2 != null) return;

    int count = 0;

    timer2 = Timer.periodic(const Duration(milliseconds: 180), (timer) {
      count = count + 1;

      setState(() {
        dice2 = random.nextInt(6) + 1;
      });

      if (count == 12) {
        timer.cancel();
        setState(() {
          done2 = true;
        });
      }
    });
  }

  // Decides what text to show at the top.
  String getWinnerText() {
    // Wait until BOTH players have rolled.
    if (done1 == false || done2 == false) {
      return 'Winner : ?';
    }

    if (dice1 > dice2) {
      return 'Winner : Player 1';
    } else if (dice2 > dice1) {
      return 'Winner : Player 2';
    } else {
      return "It's a Tie!";
    }
  }

  // Puts everything back to the starting values.
  void startAgain() {
    // Stop the timers in case a dice is still rolling.
    // "?." means: only call cancel() if the timer is not null.
    timer1?.cancel();
    timer2?.cancel();

    setState(() {
      dice1 = 1;
      dice2 = 1;
      done1 = false;
      done2 = false;
      timer1 = null;
      timer2 = null;
    });
  }

  // dispose runs when this screen is closed.
  // We stop the timers so they don't keep running in the background.
  @override
  void dispose() {
    timer1?.cancel();
    timer2?.cancel();
    super.dispose();
  }

  // ---------------- UI (WHAT WE SEE) ----------------

  // build() draws the screen. It runs again every time setState is called.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // white body

      // Top title bar
      appBar: AppBar(
        backgroundColor: Colors.green, // green title bar
        elevation: 0,                  // no shadow
        centerTitle: true,
        title: const Text(
          'Dice Game',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // Main content
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // center vertically
          children: [
            // Winner text
            Text(
              getWinnerText(),
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8), // empty space

            const Text(
              'Tap a dice to roll it',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 30),

            // The two players side by side
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                playerBox('Player 1', dice1, done1, rollDice1),
                const SizedBox(width: 20),
                playerBox('Player 2', dice2, done2, rollDice2),
              ],
            ),

            const SizedBox(height: 40),

            // Start Again button
            TextButton(
              onPressed: startAgain,
              style: TextButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white, // text color
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
              ),
              child: const Text(
                'Start Again',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // A reusable box for one player: name, dice image, and score.
  // We write it once and use it two times (for Player 1 and Player 2).
  //   name   -> "Player 1" or "Player 2"
  //   number -> the dice number to show
  //   done   -> has this player finished rolling?
  //   onTap  -> the function to run when the dice is tapped
  Widget playerBox(String name, int number, bool done, Function() onTap) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16), // rounded corners
        border: Border.all(color: Colors.green, width: 1.5),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 12),

          // GestureDetector makes the image tappable.
          GestureDetector(
            onTap: onTap,
            child: Image.asset(getImage(number), width: 110),
          ),

          const SizedBox(height: 12),

          // Show the number only after rolling is done, otherwise show 0.
          Text(
            done ? '$number' : '0',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),

          const Text('Score', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}