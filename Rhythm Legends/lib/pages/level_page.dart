import 'package:flutter/material.dart';

import '../widgets/level_button.dart';

class LevelPage extends StatelessWidget {

  const LevelPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(

        children: [

          // BACKGROUND
          SizedBox.expand(

            child: Image.asset(

              'assets/images/background.png',

              fit: BoxFit.cover,
            ),
          ),

          // OVERLAY
          Container(
            color: Colors.black.withOpacity(0.72),
          ),

          SafeArea(

            child: Padding(

              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  // BACK BUTTON
                  IconButton(

                    onPressed: () {

                      Navigator.pop(context);
                    },

                    icon: const Icon(

                      Icons.arrow_back_ios_new,

                      color: Colors.white,
                      size: 30,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    'SELECT LEVEL',

                    style: TextStyle(

                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.bold,

                      shadows: [

                        Shadow(
                          color: Colors.cyanAccent,
                          blurRadius: 25,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(

                    'Choose your rhythm challenge',

                    style: TextStyle(

                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),

                  const SizedBox(height: 45),

                  // LEVEL 1
                  LevelButton(

                    level: 1,

                    title: 'LEVEL 1',

                    subtitle: 'Easy • Basic Gestures',

                    color: Colors.greenAccent,
                  ),

                  const SizedBox(height: 22),

                  // LEVEL 2
                  LevelButton(

                    level: 2,

                    title: 'LEVEL 2',

                    subtitle: 'Medium • Faster Rhythm',

                    color: Colors.orangeAccent,
                  ),

                  const SizedBox(height: 22),

                  // LEVEL 3
                  LevelButton(

                    level: 3,

                    title: 'LEVEL 3',

                    subtitle: 'Hard • Full Challenge',

                    color: Colors.redAccent,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}