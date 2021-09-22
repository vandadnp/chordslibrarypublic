import 'package:chords/helpers/FretboardPaintingContext.dart';
import 'package:chords/models/Fretboard.dart';
import 'package:flutter/material.dart';

class FretboardPainter extends CustomPainter {
  final Fretboard fretboard;
  final FretboardPaintingContext context;

  FretboardPainter({required this.fretboard})
      : context = FretboardPaintingContext(fretboard: fretboard);

  @override
  void paint(Canvas canvas, Size size) {
    context.painters.forEach((element) {
      element.paint(canvas, size);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => context.painters
      .map((p) => p.shouldRepaint(oldDelegate))
      .reduce((value, element) => value || element);
}
