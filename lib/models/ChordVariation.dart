import 'dart:convert' as converter;

import 'package:chords/models/Fretboard.dart';

class ChordVariation {
  final String variation;
  final String infoUrl;
  final String audioUrl;
  final String audioCaption;
  final String videoUrl;
  final String embedVideoUrl;
  final String videoCaption;
  final String videoDescription;
  final String description;
  final Fretboard fretboard;

  ChordVariation({
    required this.variation,
    required this.infoUrl,
    required this.audioUrl,
    required this.audioCaption,
    required this.videoUrl,
    required this.embedVideoUrl,
    required this.videoCaption,
    required this.videoDescription,
    required this.description,
    required this.fretboard,
  });

  factory ChordVariation.fromJson(Map<String, dynamic> json) {
    return ChordVariation(
      variation: json['variation'] as String,
      infoUrl: json['infoUrl'] as String,
      audioUrl: json['audioUrl'] as String,
      audioCaption: json['audioCaption'] as String,
      videoUrl: json['videoUrl'] as String,
      embedVideoUrl: json['embedVideoUrl'] as String,
      videoCaption: json['videoCaption'] as String,
      videoDescription: json['videoDescription'] as String,
      description: json['description'] as String,
      fretboard: Fretboard.fromJson(
        converter.json.decode(
          converter.json.decode(
            json['fretboard'] as String,
          ),
        ),
      ),
    );
  }
}
