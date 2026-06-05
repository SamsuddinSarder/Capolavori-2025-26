import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/note_type.dart';
import '../services/audio_service.dart';
import '../widgets/rhythm_note.dart';
import '../widgets/target_zone.dart';

class VersusGamePage extends StatefulWidget {
  final Socket socket;
  final bool isHost;

  const VersusGamePage({
    super.key,
    required this.socket,
    required this.isHost,
  });

  @override
  State<VersusGamePage> createState() => _VersusGamePageState();
}

class _VersusGamePageState extends State<VersusGamePage> {
  final Random random = Random();

  Timer? gameLoop;
  Timer? countdownTimer;
  Timer? tapResetTimer;

  double noteY = -1.2;

  late List<NoteType> notes;
  late NoteType currentNote;

  int noteIndex = 0;

  int score = 0;
  int enemyScore = 0;

  bool noteHit = false;
  bool canInput = false;

  int countdown = 5;
  bool gameStarted = false;

  int tapsNeeded = 1;
  int currentTapProgress = 0;

  @override
  void initState() {
    super.initState();

    notes = List.generate(
      35,
      (_) => NoteType.values[random.nextInt(NoteType.values.length)],
    );

    currentNote = notes[0];

    listenSocket();
    startCountdown();
  }

  // ⏳ COUNTDOWN
  void startCountdown() {
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        setState(() {
          countdown--;

          if (countdown <= 0) {
            timer.cancel();
            startGame();
          }
        });
      },
    );
  }

  void startGame() {
    gameStarted = true;
    canInput = true;

    AudioService.playLevelMusic('music/level2.mp3');

    gameLoop = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        setState(() {
          noteY += 0.02;

          if (noteY > 1.2 && !noteHit) {
            nextNote();
          }
        });
      },
    );
  }

  void listenSocket() {
    widget.socket.listen((data) {
      final msg = utf8.decode(data).trim();

      if (msg.startsWith('SCORE:')) {
        enemyScore = int.parse(msg.replaceAll('SCORE:', ''));
        setState(() {});
      }
    });
  }

  void sendScore() {
    widget.socket.write('SCORE:$score\n');
  }

  void nextNote() {
    noteIndex++;

    if (noteIndex >= notes.length) {
      finishGame();
      return;
    }

    noteY = -1.2;
    noteHit = false;
    currentTapProgress = 0;
    currentNote = notes[noteIndex];
  }

  // 🎯 CORE HIT SYSTEM
  void evaluateGesture(NoteType gesture) {
    if (!gameStarted) return;
    if (!canInput) return;
    if (noteHit) return;

    double distance = (noteY - 0.78).abs();

    if (distance > 0.28) return;

    canInput = false;
    Future.delayed(const Duration(milliseconds: 40), () {
      canInput = true;
    });

    bool correct = gesture == currentNote;

    if (correct && distance < 0.09) {
      noteHit = true;

      score += 300;
      sendScore();

      AudioService.playPerfect();
      nextNote();
    } else if (correct && distance < 0.18) {
      noteHit = true;

      score += 150;
      sendScore();

      AudioService.playGood();
      nextNote();
    } else {
      AudioService.playMiss();
    }

    setState(() {});
  }

  // 👆 TAP + DOUBLE TAP LOGIC
  void handleTap() {
    if (!gameStarted) return;
    if (noteHit) return;

    if (currentNote == NoteType.multiTap2) {
      tapsNeeded = 2;
    } else {
      tapsNeeded = 1;
    }

    currentTapProgress++;

    tapResetTimer?.cancel();

    tapResetTimer = Timer(
      const Duration(milliseconds: 300),
      () {
        currentTapProgress = 0;
      },
    );

    if (currentTapProgress >= tapsNeeded) {
      evaluateGesture(currentNote);
      currentTapProgress = 0;
    }
  }

  void finishGame() {
    gameLoop?.cancel();
    AudioService.stopMusic();

    final win = score >= enemyScore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xFF111827),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.cyanAccent, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  blurRadius: 30,
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  win ? "WIN" : "LOSE",
                  style: TextStyle(
                    color: win ? Colors.greenAccent : Colors.redAccent,
                    fontSize: 44,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(blurRadius: 20, color: Colors.cyanAccent),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'YOUR SCORE: $score',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'ENEMY SCORE: $enemyScore',
                  style: const TextStyle(color: Colors.white70),
                ),

                const SizedBox(height: 30),

                // 🌈 NEON BUTTON
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.cyanAccent,
                          Colors.blueAccent,
                          Colors.purpleAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.7),
                          blurRadius: 30,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'RETURN TO MENU',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    gameLoop?.cancel();
    countdownTimer?.cancel();
    tapResetTimer?.cancel();
    widget.socket.destroy();
    AudioService.stopMusic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTapDown: (_) => handleTap(),

        onHorizontalDragEnd: (details) {
          if (!gameStarted) return;
          if (details.primaryVelocity == null) return;

          if (details.primaryVelocity! > 0) {
            evaluateGesture(NoteType.swipeRight);
          } else {
            evaluateGesture(NoteType.swipeLeft);
          }
        },

        onVerticalDragEnd: (details) {
          if (!gameStarted) return;
          if (details.primaryVelocity == null) return;

          if (details.primaryVelocity! > 0) {
            evaluateGesture(NoteType.swipeDown);
          } else {
            evaluateGesture(NoteType.swipeUp);
          }
        },

        child: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),

            Container(
              color: Colors.black.withOpacity(0.35),
            ),

            RhythmNote(
              y: noteY,
              type: currentNote,
            ),

            const Align(
              alignment: Alignment(0, 0.82),
              child: TargetZone(),
            ),

            // ⏳ COUNTDOWN
            if (!gameStarted)
              Center(
                child: Text(
                  countdown > 0 ? '$countdown' : 'GO!',
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 30,
                        color: Colors.cyanAccent,
                      )
                    ],
                  ),
                ),
              ),

            Positioned(
              top: 60,
              left: 20,
              child: Text(
                'YOU: $score',
                style: const TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),

            Positioned(
              top: 100,
              left: 20,
              child: Text(
                'ENEMY: $enemyScore',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}