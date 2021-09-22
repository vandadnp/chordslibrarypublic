import 'package:chords/models/ChordVariation.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class ChordAudioView extends StatelessWidget {
  final ChordVariation chordVariation;

  const ChordAudioView({
    Key? key,
    required this.chordVariation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          AssetsAudioPlayer.playAndForget(
            Audio.network(chordVariation.audioUrl),
          );
        } catch (e) {
          print('Exception while playing audio from url: $e');
        }
      },
      child: Column(
        children: [
          Icon(
            Icons.play_arrow,
            size: 200,
          ),
          // Text(chordVariation.audioCaption),
          Text('Press this button to hear the sound of this chord!')
        ],
      ),
    );
  }
}
