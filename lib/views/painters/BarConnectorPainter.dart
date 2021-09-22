import 'package:chords/helpers/FretboardPaintingContext.dart';
import 'package:flutter/material.dart';

class BarConnectorPainter extends CustomPainter {
  final FretboardPaintingContext context;

  BarConnectorPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final painter = context.barConnectorPainter;
    final fretboardRect = context.fretboardRect(size);
    final barLine = context.barLine(fretboardRect);
    if (barLine == null) {
      return;
    }
    canvas.drawLine(barLine.p1, barLine.p2, painter);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
