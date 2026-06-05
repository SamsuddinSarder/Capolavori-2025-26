import 'package:flutter/material.dart';

import '../models/note_type.dart';

class RhythmNote extends StatelessWidget {
  final double y;
  final NoteType type;

  const RhythmNote({
    super.key,
    required this.y,
    required this.type,
  });

  IconData getIcon() {
    switch (type) {
      case NoteType.tap:
        return Icons.circle;

      case NoteType.multiTap2:
        return Icons.looks_two;

      case NoteType.swipeLeft:
        return Icons.arrow_back;

      case NoteType.swipeRight:
        return Icons.arrow_forward;

      case NoteType.swipeUp:
        return Icons.arrow_upward;

      case NoteType.swipeDown:
        return Icons.arrow_downward;
    }
  }

  Color getColor() {
    switch (type) {
      case NoteType.tap:
        return Colors.cyanAccent;

      case NoteType.multiTap2:
        return Colors.orangeAccent;

      case NoteType.swipeLeft:
      case NoteType.swipeRight:
      case NoteType.swipeUp:
      case NoteType.swipeDown:
        return Colors.greenAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(0, y),
      child: Container(
        width: 95,
        height: 95,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: getColor().withOpacity(0.18),
          border: Border.all(
            color: getColor(),
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: getColor().withOpacity(0.6),
              blurRadius: 20,
            ),
          ],
        ),
        child: Icon(
          getIcon(),
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }
}