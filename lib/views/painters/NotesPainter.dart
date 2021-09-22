import 'package:chords/helpers/FretboardPaintingContext.dart';
import 'package:flutter/material.dart';

class NotesPainter extends CustomPainter {
  final FretboardPaintingContext context;

  NotesPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final painter = context.notesPainter;
    final fretboardRect = context.fretboardRect(size);

    for (var noteRect in context.noteRects(fretboardRect)) {
      canvas.drawOval(
        noteRect,
        painter,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
