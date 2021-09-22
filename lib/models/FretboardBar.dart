import 'package:chords/models/OneBasedIndex.dart';
import 'package:chords/models/ZeroBasedIndex.dart';

class FretboardBar {
  final ZeroBasedIndex fret;
  final List<OneBasedIndex> strings;

  FretboardBar({required this.fret, required this.strings});

  factory FretboardBar.fromJson(Map<String, dynamic> json) {
    return FretboardBar(
      fret: ZeroBasedIndex.parse(json['fret'] as String),
      strings: List<String>.from(json['strings'])
          .map((s) => OneBasedIndex.parse(s))
          .toList(),
    );
  }
}
