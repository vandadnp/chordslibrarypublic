import 'package:chords/helpers/FretboardPaintingContext.dart';
import 'package:flutter/material.dart';

class StringsPainter extends CustomPainter {
  final FretboardPaintingContext context;

  StringsPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final fretboardRect = context.fretboardRect(size);
    final spaceBetweenStrings = context.spaceBetweenStrings(fretboardRect);

    final painter = context.stringsPainter;

    // draw the strings from left to right
    var x = fretboardRect.right;
    for (var i = 0; i < context.stringCount; i++) {
      painter.strokeWidth = context.strokeWidthForString(i);
      canvas.drawLine(
        Offset(x, fretboardRect.top),
        Offset(x, fretboardRect.bottom),
        painter,
      );
      x -= spaceBetweenStrings;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
