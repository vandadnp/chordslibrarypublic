import 'package:chords/helpers/FretboardPaintingContext.dart';
import 'package:flutter/material.dart';

class FretsPainter extends CustomPainter {
  final FretboardPaintingContext context;

  FretsPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final painter = context.fretsPainter;
    final fretboardRect = context.fretboardRect(size);

    var y = context.yPositionForFirstFret(fretboardRect);
    for (var i = 0; i < context.numberOffretsToDraw; i++) {
      canvas.drawLine(
        Offset(fretboardRect.left, y),
        Offset(fretboardRect.right, y),
        painter,
      );
      y += context.spaceBetweenFrets(fretboardRect);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
