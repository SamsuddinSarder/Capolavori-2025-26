import 'package:flutter/material.dart';

import '../pages/game_page.dart';

class LevelButton extends StatelessWidget {

  final int level;

  final String title;

  final String subtitle;

  final Color color;

  const LevelButton({

    super.key,

    required this.level,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) => GamePage(level: level),
          ),
        );
      },

      child: Container(

        width: double.infinity,
        height: 125,

        padding: const EdgeInsets.all(22),

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(28),

          gradient: LinearGradient(

            colors: [

              color.withOpacity(0.92),
              color.withOpacity(0.4),
            ],
          ),

          border: Border.all(
            color: color,
            width: 2,
          ),

          boxShadow: [

            BoxShadow(

              color: color.withOpacity(0.4),

              blurRadius: 28,
              spreadRadius: 2,
            ),
          ],
        ),

        child: Row(

          children: [

            Container(

              width: 70,
              height: 70,

              decoration: BoxDecoration(

                shape: BoxShape.circle,

                color: Colors.white.withOpacity(0.12),
              ),

              child: Center(

                child: Text(

                  '$level',

                  style: const TextStyle(

                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 24),

            Expanded(

              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(

                    title,

                    style: const TextStyle(

                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(

                    subtitle,

                    style: const TextStyle(

                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(

              Icons.play_arrow_rounded,

              color: Colors.white,
              size: 42,
            ),
          ],
        ),
      ),
    );
  }
}