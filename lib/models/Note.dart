import 'package:chords/models/Fretboard.dart';
import 'package:chords/models/FretboardBar.dart';
import 'package:chords/models/OneBasedIndex.dart';
import 'package:chords/models/ZeroBasedIndex.dart';

class Note {
  final ZeroBasedIndex fret; // 0 is an open fret
  final OneBasedIndex string;

  Note({required this.fret, required this.string}); // 1 based

  static List<Note> notesFrom({FretboardBar? bar}) {
    if (bar == null) {
      return [];
    }

    return bar.strings.map((e) => Note(fret: bar.fret, string: e)).toList();
  }

  static List<Note> allNotesFrom({required Fretboard fretboard}) =>
      fretboard.strings.keys
          .map(
            (string) => Note(
                fret: ZeroBasedIndex.parse(fretboard.strings[string]!),
                string: OneBasedIndex.parse(string)),
          )
          .toList() +
      notesFrom(bar: fretboard.bar);

  @override
  String toString() => 'fret: $fret, string: $string';
}
