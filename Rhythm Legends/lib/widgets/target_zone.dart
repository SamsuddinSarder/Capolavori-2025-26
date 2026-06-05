import 'package:flutter/material.dart';

class TargetZone extends StatelessWidget {

  const TargetZone({super.key});

  @override
  Widget build(BuildContext context) {

    return Align(

      alignment: const Alignment(0, 0.82),

      child: Container(

        width: 170,
        height: 170,

        decoration: BoxDecoration(

          shape: BoxShape.circle,

          border: Border.all(

            color: Colors.cyanAccent,
            width: 5,
          ),

          boxShadow: [

            BoxShadow(

              color: Colors.cyanAccent.withOpacity(0.8),

              blurRadius: 35,
              spreadRadius: 6,
            ),
          ],

          gradient: RadialGradient(

            colors: [

              Colors.cyanAccent.withOpacity(0.35),
              Colors.transparent,
            ],
          ),
        ),

        child: Center(

          child: Container(

            width: 70,
            height: 70,

            decoration: BoxDecoration(

              shape: BoxShape.circle,

              color: Colors.cyanAccent.withOpacity(0.15),

              border: Border.all(

                color: Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}