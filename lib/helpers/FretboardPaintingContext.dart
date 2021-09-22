import 'package:chords/models/Fretboard.dart';
import 'package:chords/models/FretIndex.dart';
import 'package:chords/models/Line.dart';
import 'package:chords/models/Note.dart';
import 'package:chords/models/OneBasedIndex.dart';
import 'package:chords/views/painters/BarConnectorPainter.dart';
import 'package:chords/views/painters/FretIndexPainter.dart';
import 'package:chords/views/painters/FretsPainter.dart';
import 'package:chords/views/painters/NotesPainter.dart';
import 'package:chords/views/painters/StringsPainter.dart';
import 'package:flutter/material.dart';
import 'package:chords/extentions/Array+MinMax.dart';

class FretboardPaintingContext {
  final Fretboard fretboard;
  final EdgeInsets edgeInsets;
  final int stringCount;
  final double noteRadius;
  late final List<Note> notes;
  late final FretsPainter _fretsPainter;
  late final StringsPainter _stringsPainter;
  late final FretIndexPainter _fretIndexPainter;
  late final NotesPainter _notesPainter;
  late final BarConnectorPainter _barConnectorPainter;
  late final List<CustomPainter> _painters;

  FretboardPaintingContext({
    this.edgeInsets = const EdgeInsets.fromLTRB(
      64.0,
      64.0,
      32.0,
      32.0,
    ),
    this.stringCount = 6,
    this.noteRadius = 20.0,
    required this.fretboard,
  }) {
    notes = Note.allNotesFrom(fretboard: fretboard);
    _fretsPainter = FretsPainter(this);
    _stringsPainter = StringsPainter(this);
    _fretIndexPainter = FretIndexPainter(this);
    _barConnectorPainter = BarConnectorPainter(this);
    _notesPainter = NotesPainter(this);
    _painters = [
      _fretsPainter,
      _stringsPainter,
      _fretIndexPainter,
      _barConnectorPainter,
      _notesPainter,
    ];
  }

  Line? barLine(Rect fretboardRect) {
    final bar = fretboard.bar;

    if (bar == null) {
      return null;
    }

    final stringValues = bar.strings.map((s) => s.value).toList();
    final leftmostNoteString = stringValues.max;
    final rightmostNoteString = stringValues.min;

    final leftmostNote =
        Note(fret: bar.fret, string: OneBasedIndex(leftmostNoteString));
    final rightmostNote =
        Note(fret: bar.fret, string: OneBasedIndex(rightmostNoteString));
    final leftmostNoteRect = _rectForNote(leftmostNote, fretboardRect);
    final rightmostNoteRect = _rectForNote(rightmostNote, fretboardRect);

    return Line(leftmostNoteRect.center, rightmostNoteRect.center);
  }

// 0 based, fret 1 becomes 0, 2 is 1 and so forth
  int _viewFretIndexFor(int fret) =>
      fret <= 2 ? fret - 1 : fret - _indexOfFirstFret.value;

  OneBasedIndex get _indexOfFirstFret {
    final fretIndices = notes.map((e) => e.fret.value).toList()..sort();
    if (fretIndices.first <= 2) {
      return OneBasedIndex(1);
    } else {
      return OneBasedIndex(fretIndices.min - 1);
    }
  }

  double _centerYPositionForFretIndex(
      OneBasedIndex fretIndex, Rect fretboardRect) {
    final spaceBetweenFrets = this.spaceBetweenFrets(fretboardRect);
    return fretboardRect.top +
        ((fretIndex.value - _indexOfFirstFret.value) * spaceBetweenFrets) +
        (spaceBetweenFrets / 2.0);
  }

  double _centerXPositionForFretIndex(Rect fretboardRect) =>
      fretboardRect.left / 2.0;

  List<FretIndex> fretIndexRects(Rect fretboardRect) => List<int>.generate(
          numberOffretsToDraw, (index) => _indexOfFirstFret.value + index)
      .map((fretIndex) => OneBasedIndex(fretIndex))
      .map(
        (fretIndex) => FretIndex(
          fretIndex,
          Rect.fromCenter(
            center: Offset(
              _centerXPositionForFretIndex(fretboardRect),
              _centerYPositionForFretIndex(fretIndex, fretboardRect),
            ),
            width: noteRadius * 2.0,
            height: noteRadius * 2.0,
          ),
        ),
      )
      .toList();

  List<Rect> noteRects(Rect fretboardRect) =>
      notes.map((n) => _rectForNote(n, fretboardRect)).toList();

  double _centerXPositionForNote(
    Note note,
    Rect fretboardRect,
  ) =>
      fretboardRect.right -
      ((note.string.toZeroBasedIndex).toDouble() *
          spaceBetweenStrings(fretboardRect));

  double _centerYPositionForNote(
    Note note,
    Rect fretboardRect,
  ) {
    final viewFretIndexForNote = _viewFretIndexFor(note.fret.value);
    final spaceBetweenFrets = this.spaceBetweenFrets(fretboardRect);
    return fretboardRect.top +
        (viewFretIndexForNote * spaceBetweenFrets) +
        (spaceBetweenFrets / 2.0);
  }

  Rect _rectForNote(
    Note note,
    Rect fretboardRect,
  ) =>
      Rect.fromCenter(
        center: Offset(
          _centerXPositionForNote(
            note,
            fretboardRect,
          ),
          _centerYPositionForNote(
            note,
            fretboardRect,
          ),
        ),
        width: noteRadius * 2.0,
        height: noteRadius * 2.0,
      );

  List<CustomPainter> get painters => _painters;

  Rect fretboardRect(Size size) => Rect.fromLTWH(
        edgeInsets.left,
        edgeInsets.top,
        size.width - edgeInsets.horizontal,
        size.height - edgeInsets.horizontal,
      );

  double spaceBetweenStrings(Rect fretboardRect) =>
      fretboardRect.width / (stringCount - 1).toDouble();

  bool get _hasNotesOnTheFirstOrSecondFret =>
      notes.map((e) => e.fret.value).where((e) => e <= 2 && e > 0).isNotEmpty;

  int get numberOffretsToDraw => notes.map((e) => e.fret).toSet().length + 2;

  double spaceBetweenFrets(Rect fretboardRect) =>
      fretboardRect.height / numberOffretsToDraw.toDouble();

  double yPositionForFirstFret(Rect fretboardRect) =>
      _hasNotesOnTheFirstOrSecondFret
          ? fretboardRect.top
          : fretboardRect.top + spaceBetweenFrets(fretboardRect);

  // index is 0 based, with 0 being the
  // thinnest string to the right of the context
  double strokeWidthForString(int stringIndex) => (stringIndex + 1).toDouble();

  Paint get stringsPainter => Paint()
    ..color = Colors.amber[100]!
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round;

  Paint get fretsPainter => Paint()
    ..color = Colors.grey[400]!
    ..style = PaintingStyle.stroke
    ..strokeWidth = 0.5
    ..strokeCap = StrokeCap.round;

  Paint get barConnectorPainter => Paint()
    ..color = Colors.yellow[800]!
    ..strokeWidth = 10
    ..style = PaintingStyle.fill;

  Paint get notesPainter => Paint()
    ..color = Colors.yellow[100]!
    ..style = PaintingStyle.fill;

  TextPainter fretIndexPainter(FretIndex fretIndex) {
    final span = TextSpan(
      text: fretIndex.index.value.toString(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 33,
      ),
    );
    final painter = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 1,
    )..layout(maxWidth: fretIndex.rect.width);
    return painter;
  }
}
