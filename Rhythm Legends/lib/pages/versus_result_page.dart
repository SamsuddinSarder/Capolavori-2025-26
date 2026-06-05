import 'package:flutter/material.dart';

class VersusResultPage
    extends StatelessWidget {
  final bool win;

  final int score;

  final int enemyScore;

  const VersusResultPage({
    super.key,
    required this.win,
    required this.score,
    required this.enemyScore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding:
              const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Text(
                win
                    ? ''
                    : '',
                style: TextStyle(
                  color: win
                      ? Colors.greenAccent
                      : Colors.redAccent,
                  fontSize: 52,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Text(
                'YOUR SCORE: $score',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'ENEMY SCORE: $enemyScore',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 22,
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.cyanAccent,
                    foregroundColor:
                        Colors.black,
                  ),
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      (route) =>
                          route.isFirst,
                    );
                  },
                  child: const Text(
                    'RETURN TO MENU',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}