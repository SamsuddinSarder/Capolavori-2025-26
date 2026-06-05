import 'package:flutter/material.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        title: const Text('CREDITS'),
        backgroundColor: Colors.deepPurple,
      ),

      body: Center(

        child: Padding(

          padding: const EdgeInsets.all(30),

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              const Icon(

                Icons.music_note,

                size: 100,
                color: Colors.cyanAccent,
              ),

              const SizedBox(height: 30),

              const Text(

                'RHYTHM LEGEND',
                textAlign: TextAlign.center,

                style: TextStyle(

                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,

                  shadows: [

                    Shadow(
                      color: Colors.cyanAccent,
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              const Text(

                'Progetto di TPSIT\nITIS C. Zuccante',

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: Colors.white70,
                  fontSize: 26,
                ),
              ),

              const SizedBox(height: 30),

              const Text(

                'Realizzato da\nSarder Samsuddin',

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: Colors.cyanAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              const Text(

                'Sviluppato con Flutter\nGestureDetector + Motion System',

                textAlign: TextAlign.center,

                style: TextStyle(

                  color: Colors.white54,
                  fontSize: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}