import 'package:chords/helpers/FretboardPaintingContext.dart';
import 'package:flutter/material.dart';

extension TextPainting on Canvas {
  void drawText(TextPainter text, Offset offset) {
    text.paint(this, offset);
  }
}

class FretIndexPainter extends CustomPainter {
  final FretboardPaintingContext context;

  FretIndexPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    final fretboardRect = context.fretboardRect(size);
    final fretIndices = context.fretIndexRects(fretboardRect);

    fretIndices.forEach((fretIndex) {
      final painter = context.fretIndexPainter(fretIndex);
      canvas.drawText(
        painter,
        Offset(
          fretIndex.rect.left,
          fretIndex.rect.top,
        ),
      );
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
