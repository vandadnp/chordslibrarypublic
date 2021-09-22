import 'package:chords/models/ChordVariation.dart';
import 'package:chords/views/ChordVideoView.dart';
import 'package:chords/views/FretboardView.dart';
import 'package:chords/views/ChordAudioView.dart';
import 'package:flutter/material.dart';

class ChordVariationView extends StatelessWidget {
  final ChordVariation chordVariation;

  const ChordVariationView({Key? key, required this.chordVariation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChordVideoView(chordVariation: chordVariation),
            Separator(),
            Container(
              color: Colors.grey[900],
              child: ChordAudioView(chordVariation: chordVariation),
            ),
            Separator(),
            // Text(chordVariation.description),
            Separator(
              height: 10,
            ),
            FretboardView(
              chordVariation: chordVariation,
            ),
          ],
        ),
      ),
    );
  }
}

class Separator extends StatelessWidget {
  final double height;

  const Separator({Key? key, this.height = 32.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
    );
  }
}
