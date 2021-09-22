import 'package:chords/models/FretboardBar.dart';

class Fretboard {
  final FretboardBar? bar;
  final Map<String, String> strings;

  Fretboard({this.bar, required this.strings});

  factory Fretboard.fromJson(Map<String, dynamic> json) {
    return Fretboard(
      bar: json['bar'] != null ? FretboardBar.fromJson(json['bar']) : null,
      strings: Map<String, String>.from(json['strings']),
    );
  }
}
