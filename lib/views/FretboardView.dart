import 'package:chords/models/ChordVariation.dart';
import 'package:chords/views/painters/FretboardPainter.dart';
import 'package:flutter/material.dart';

class FretboardView extends StatelessWidget {
  final ChordVariation chordVariation;

  const FretboardView({Key? key, required this.chordVariation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          color: Colors.black,
          child: CustomPaint(
            size: Size(
              constraints.maxWidth,
              constraints.maxWidth * 1.5,
            ),
            painter: FretboardPainter(
              fretboard: chordVariation.fretboard,
            ),
          ),
        );
      },
    );
  }
}
