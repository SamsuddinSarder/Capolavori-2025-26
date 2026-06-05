import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../models/note_type.dart';
import '../services/audio_service.dart';
import '../widgets/rhythm_note.dart';
import '../widgets/target_zone.dart';

class GamePage extends StatefulWidget {
  final int level;

  const GamePage({
    super.key,
    required this.level,
  });

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Random random = Random();

  Timer? gameLoop;

  Timer? tapComboTimer;

  double noteY = -1.2;

  late double speed;

  bool noteHit = false;

  bool canInput = true;

  late NoteType currentNote;

  late List<NoteType> availableNotes;

  int tapsNeeded = 1;

  int currentTapProgress = 0;

  int score = 0;

  int combo = 0;

  int maxCombo = 0;

  int perfectHits = 0;

  int goodHits = 0;

  int missHits = 0;

  int totalNotes = 20;

  int notesCompleted = 0;

  String feedback = '';

  Color feedbackColor = Colors.white;

  @override
  void initState() {
    super.initState();

    setupLevel();

    spawnNote();

    startGame();

    if (widget.level == 1) {
      AudioService.playLevelMusic(
        'music/level1.mp3',
      );
    }

    if (widget.level == 2) {
      AudioService.playLevelMusic(
        'music/level2.mp3',
      );
    }

    if (widget.level == 3) {
      AudioService.playLevelMusic(
        'music/level3.mp3',
      );
    }
  }

  void setupLevel() {
    switch (widget.level) {
      case 1:
        speed = 0.014;

        totalNotes = 20;

        availableNotes = [
          NoteType.tap,
          NoteType.multiTap2,
          NoteType.swipeLeft,
          NoteType.swipeRight,
        ];

        break;

      case 2:
        speed = 0.021;

        totalNotes = 35;

        availableNotes = [
          NoteType.tap,
          NoteType.multiTap2,
          NoteType.swipeLeft,
          NoteType.swipeRight,
          NoteType.swipeUp,
          NoteType.swipeDown,
        ];

        break;

      default:
        speed = 0.03;

        totalNotes = 50;

        availableNotes = [
          NoteType.tap,
          NoteType.multiTap2,
          NoteType.swipeLeft,
          NoteType.swipeRight,
          NoteType.swipeUp,
          NoteType.swipeDown,
        ];
    }
  }

  void startGame() {
    gameLoop?.cancel();

    gameLoop = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        setState(() {
          noteY += speed;

          if (noteY > 1.2 && !noteHit) {
            combo = 0;

            missHits++;

            feedback = 'MISS';

            feedbackColor = Colors.redAccent;

            AudioService.playMiss();

            nextNote();
          }
        });
      },
    );
  }

  void spawnNote() {
    noteY = -1.2;

    noteHit = false;

    currentTapProgress = 0;

    currentNote = availableNotes[
        random.nextInt(availableNotes.length)];

    if (currentNote == NoteType.tap) {
      tapsNeeded = 1;
    } else if (currentNote ==
        NoteType.multiTap2) {
      tapsNeeded = 2;
    } else {
      tapsNeeded = 1;
    }
  }

  void nextNote() {
    notesCompleted++;

    if (notesCompleted >= totalNotes) {
      finishGame();

      return;
    }

    spawnNote();
  }

  double getAccuracy() {
    int totalHits =
        perfectHits + goodHits + missHits;

    if (totalHits == 0) return 100;

    double accuracy =
        ((perfectHits * 1.0) +
                (goodHits * 0.6)) /
            totalHits;

    return accuracy * 100;
  }

  String getRank() {
    double accuracy = getAccuracy();

    if (accuracy >= 95) return 'S';

    if (accuracy >= 85) return 'A';

    if (accuracy >= 70) return 'B';

    if (accuracy >= 55) return 'C';

    return 'D';
  }

  void handleTap() {
    if (!canInput) return;

    if (noteHit) return;

    double targetDistance =
        (noteY - 0.78).abs();

    if (targetDistance > 0.28) {
      return;
    }

    if (currentNote == NoteType.tap ||
        currentNote ==
            NoteType.multiTap2) {
      currentTapProgress++;

      tapComboTimer?.cancel();

      tapComboTimer = Timer(
        const Duration(milliseconds: 320),
        () {
          currentTapProgress = 0;
        },
      );

      if (currentTapProgress >= tapsNeeded) {
        evaluateGesture(currentNote);

        currentTapProgress = 0;
      }
    }
  }

  void evaluateGesture(NoteType gesture) {
    if (!canInput) return;

    if (noteHit) return;

    canInput = false;

    Future.delayed(
      const Duration(milliseconds: 40),
      () {
        canInput = true;
      },
    );

    double targetDistance =
        (noteY - 0.78).abs();

    bool correctGesture =
        gesture == currentNote;

    if (targetDistance > 0.28) {
      return;
    }

    if (correctGesture &&
        targetDistance < 0.09) {
      noteHit = true;

      perfectHits++;

      score += 300;

      combo++;

      if (combo > maxCombo) {
        maxCombo = combo;
      }

      feedback = 'PERFECT';

      feedbackColor =
          Colors.cyanAccent;

      AudioService.playPerfect();

      nextNote();
    } else if (correctGesture &&
        targetDistance < 0.18) {
      noteHit = true;

      goodHits++;

      score += 150;

      combo++;

      if (combo > maxCombo) {
        maxCombo = combo;
      }

      feedback = 'GOOD';

      feedbackColor =
          Colors.greenAccent;

      AudioService.playGood();

      nextNote();
    } else {
      combo = 0;

      missHits++;

      feedback = 'MISS';

      feedbackColor =
          Colors.redAccent;

      AudioService.playMiss();
    }

    setState(() {});
  }

    void finishGame() {
    gameLoop?.cancel();

    AudioService.stopMusic();

    double accuracy = getAccuracy();

    String rank = getRank();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.cyanAccent
                      .withOpacity(0.18),
                  Colors.purpleAccent
                      .withOpacity(0.18),
                ],
              ),
              border: Border.all(
                color: Colors.cyanAccent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent
                      .withOpacity(0.45),
                  blurRadius: 28,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  rank,
                  style: TextStyle(
                    color:
                        Colors.yellowAccent,
                    fontSize: 95,
                    fontWeight:
                        FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors
                            .yellowAccent
                            .withOpacity(0.8),
                        blurRadius: 30,
                      ),
                    ],
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                const Text(
                  'LEVEL COMPLETE',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                buildStat(
                  'Score',
                  score.toString(),
                ),

                buildStat(
                  'Accuracy',
                  '${accuracy.toStringAsFixed(1)}%',
                ),

                buildStat(
                  'Perfect',
                  perfectHits.toString(),
                ),

                buildStat(
                  'Good',
                  goodHits.toString(),
                ),

                buildStat(
                  'Miss',
                  missHits.toString(),
                ),

                buildStat(
                  'Max Combo',
                  maxCombo.toString(),
                ),

                const SizedBox(
                  height: 28,
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.pop(
                      context,
                    );

                    Navigator.pop(
                      context,
                    );
                  },
                  child: Container(
                    width:
                        double.infinity,
                    height: 68,
                    decoration:
                        BoxDecoration(
                      borderRadius:
                          BorderRadius
                              .circular(
                        22,
                      ),
                      gradient:
                          const LinearGradient(
                        colors: [
                          Colors
                              .cyanAccent,
                          Colors
                              .blueAccent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors
                              .cyanAccent
                              .withOpacity(
                            0.5,
                          ),
                          blurRadius:
                              24,
                          spreadRadius:
                              2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'RETURN TO MENU',
                        style: TextStyle(
                          color:
                              Colors.black,
                          fontSize: 21,
                          fontWeight:
                              FontWeight
                                  .bold,
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

  Widget buildStat(
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 18,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void pauseGame() {
    gameLoop?.cancel();

    AudioService.pauseMusic();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(28),
              color: const Color(0xFF111827),
              border: Border.all(
                color: Colors.cyanAccent
                    .withOpacity(0.7),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.cyanAccent
                      .withOpacity(0.25),
                  blurRadius: 25,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                const Icon(
                  Icons.pause_circle_filled,
                  color: Colors.cyanAccent,
                  size: 82,
                ),

                const SizedBox(height: 18),

                const Text(
                  'GAME PAUSED',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight:
                        FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors
                              .cyanAccent,
                      foregroundColor:
                          Colors.black,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context);

                      startGame();

                      AudioService
                          .resumeMusic();
                    },
                    child: const Text(
                      'RESUME',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style:
                        ElevatedButton
                            .styleFrom(
                      backgroundColor:
                          Colors
                              .deepPurpleAccent,
                      foregroundColor:
                          Colors.white,
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          18,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(
                          context);

                      Navigator.pop(
                          context);
                    },
                    child: const Text(
                      'RETURN TO MENU',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight
                                .bold,
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

    tapComboTimer?.cancel();

    AudioService.stopMusic();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double accuracy = getAccuracy();

    int notesLeft =
        totalNotes - notesCompleted;

    return GestureDetector(
      onTapDown: (_) {
        handleTap();
      },

      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          evaluateGesture(
            NoteType.swipeRight,
          );
        } else {
          evaluateGesture(
            NoteType.swipeLeft,
          );
        }
      },

      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! > 0) {
          evaluateGesture(
            NoteType.swipeDown,
          );
        } else {
          evaluateGesture(
            NoteType.swipeUp,
          );
        }
      },

      child: Scaffold(
        body: Stack(
          children: [
            SizedBox.expand(
              child: Image.asset(
                'assets/images/background.png',
                fit: BoxFit.cover,
              ),
            ),

            Container(
              color: Colors.black
                  .withOpacity(0.35),
            ),

            RhythmNote(
              y: noteY,
              type: currentNote,
            ),

            const Align(
              alignment:
                  Alignment(0, 0.82),
              child: TargetZone(),
            ),

            Positioned(
              top: 55,
              left: 20,
              right: 20,
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment
                        .spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        'SCORE: $score',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 22,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 6),

                      Text(
                        'COMBO: $combo',
                        style:
                            const TextStyle(
                          color: Colors
                              .cyanAccent,
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .end,
                    children: [
                      Text(
                        'LEFT: $notesLeft',
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const SizedBox(
                          height: 6),

                      Text(
                        'ACC: ${accuracy.toStringAsFixed(1)}%',
                        style:
                            const TextStyle(
                          color: Colors
                              .greenAccent,
                          fontSize: 18,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Center(
              child: Text(
                feedback,
                style: TextStyle(
                  color: feedbackColor,
                  fontSize: 42,
                  fontWeight:
                      FontWeight.bold,
                  shadows: [
                    Shadow(
                      color:
                          feedbackColor,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 130,
              right: 20,
              child: IconButton(
                onPressed: pauseGame,
                icon: const Icon(
                  Icons.pause_circle,
                  color: Colors.white,
                  size: 44,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}