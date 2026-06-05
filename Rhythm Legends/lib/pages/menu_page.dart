import 'package:flutter/material.dart';

import 'credits_page.dart';
import 'level_page.dart';
import 'tutorial_page.dart';
import 'versus_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  Widget buildButton({
    required String text,
    required Color c1,
    required Color c2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 70,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(22),
          gradient: LinearGradient(
            colors: [c1, c2],
          ),
          boxShadow: [
            BoxShadow(
              color: c1.withOpacity(0.4),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                .withOpacity(0.1),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.all(
                    24,
                  ),
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .center,
                    children: [
                      const Text(
                        '',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 52,
                          fontWeight:
                              FontWeight
                                  .bold,
                          height: 0.95,
                          letterSpacing:
                              2,
                        ),
                      ),

                      const SizedBox(
                        height: 70,
                      ),

                      buildButton(
                        text: 'START',
                        c1:
                            Colors.cyanAccent,
                        c2:
                            Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const LevelPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      buildButton(
                        text: 'VERSUS',
                        c1:
                            Colors.redAccent,
                        c2:
                            Colors
                                .deepPurpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const VersusPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      buildButton(
                        text: 'TUTORIAL',
                        c1:
                            Colors.orangeAccent,
                        c2:
                            Colors.deepOrange,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const TutorialPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 22,
                      ),

                      buildButton(
                        text: 'CREDITS',
                        c1:
                            Colors.greenAccent,
                        c2: Colors.green,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const CreditsPage(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      const Text(
                        'TPSIT Rhythm Game Project',
                        style: TextStyle(
                          color:
                              Colors.white54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}