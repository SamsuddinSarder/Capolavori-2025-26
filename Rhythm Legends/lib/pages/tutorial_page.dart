import 'package:flutter/material.dart';

class TutorialPage extends StatelessWidget {

  const TutorialPage({super.key});

  Widget buildGesture({

    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {

    return Container(

      margin: const EdgeInsets.only(bottom: 25),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(

        color: Colors.white.withOpacity(0.05),

        borderRadius: BorderRadius.circular(22),

        border: Border.all(
          color: color,
          width: 2,
        ),

        boxShadow: [

          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 18,
          ),
        ],
      ),

      child: Row(

        children: [

          Icon(
            icon,
            color: color,
            size: 45,
          ),

          const SizedBox(width: 20),

          Expanded(

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                Text(

                  title,

                  style: TextStyle(

                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(

                  description,

                  style: const TextStyle(

                    color: Colors.white70,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text('TUTORIAL'),

        backgroundColor: Colors.deepPurple,
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(24),

        child: Column(

          children: [

            const SizedBox(height: 20),

            const Text(

              'MATCH THE GESTURE\nWITH PERFECT TIMING',

              textAlign: TextAlign.center,

              style: TextStyle(

                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,

                shadows: [

                  Shadow(
                    color: Colors.cyanAccent,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 45),

            buildGesture(

              icon: Icons.circle,

              title: 'TAP',

              description:
                  'Tap when the circle reaches the target zone.',

              color: Colors.cyanAccent,
            ),

            buildGesture(

              icon: Icons.looks_two_outlined,

              title: 'DOUBLE TAP',

              description:
                  'Double tap quickly for star notes.',

              color: const Color.fromARGB(255, 255, 166, 0),
            ),

            buildGesture(

              icon: Icons.arrow_forward,

              title: 'SWIPE RIGHT',

              description:
                  'Swipe right when the arrow hits the zone.',

              color: Colors.greenAccent,
            ),

            buildGesture(

              icon: Icons.arrow_back,

              title: 'SWIPE LEFT',

              description:
                  'Swipe left at the perfect timing.',

              color: Colors.pinkAccent,
            ),

            buildGesture(

              icon: Icons.arrow_upward,

              title: 'SWIPE UP',

              description:
                  'Swipe up for upward notes.',

              color: Colors.orangeAccent,
            ),

            buildGesture(

              icon: Icons.arrow_downward,

              title: 'SWIPE DOWN',

              description:
                  'Swipe down before the note passes.',

              color: Colors.purpleAccent,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}