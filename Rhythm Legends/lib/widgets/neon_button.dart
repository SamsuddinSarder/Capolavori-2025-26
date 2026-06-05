import 'package:flutter/material.dart';

class NeonButton extends StatelessWidget {

  final String text;

  final VoidCallback onPressed;

  final IconData icon;

  final Color color;

  const NeonButton({

    super.key,

    required this.text,
    required this.onPressed,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(

      onTap: onPressed,

      child: AnimatedContainer(

        duration: const Duration(milliseconds: 200),

        width: double.infinity,
        height: 78,

        decoration: BoxDecoration(

          borderRadius: BorderRadius.circular(24),

          gradient: LinearGradient(

            colors: [

              color.withOpacity(0.9),
              color.withOpacity(0.5),
            ],
          ),

          border: Border.all(
            color: color,
            width: 2,
          ),

          boxShadow: [

            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 25,
              spreadRadius: 1,
            ),
          ],
        ),

        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [

            Icon(
              icon,
              color: Colors.white,
              size: 34,
            ),

            const SizedBox(width: 15),

            Text(

              text,

              style: const TextStyle(

                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}