import 'package:chords/views/ChordView.dart';
import 'package:chords/views/FailedToGetDataView.dart';
import 'package:chords/views/LoadingView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/ChordCategory.dart';
import '../models/Chord.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChordCategoryDetailsView extends StatefulWidget {
  final ChordCategory chordCategory;

  const ChordCategoryDetailsView({Key? key, required this.chordCategory})
      : super(key: key);

  @override
  _ChordCategoryDetailsViewState createState() =>
      _ChordCategoryDetailsViewState();
}

class _ChordCategoryDetailsViewState extends State<ChordCategoryDetailsView> {
  Future<List<Chord>> getChords() async {
    return FirebaseFirestore.instance
        .collection(widget.chordCategory.chordsCollection)
        .get()
        .asStream()
        .map((event) => event.docs)
        .map(
          (docs) => docs.map(
            (doc) {
              var data = doc.data();
              return Chord(
                category: data['category'] as String,
                name: data['name'] as String,
                root: data['root'] as String,
                path: doc.reference.path,
              );
            },
          ).toList(),
        )
        .firstWhere((element) => element.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chordCategory.name),
      ),
      body: FutureBuilder(
          future: getChords(),
          builder: (context, AsyncSnapshot<List<Chord>> chords) {
            switch (chords.connectionState) {
              case ConnectionState.waiting:
                {
                  return LoadingView();
                }
              case ConnectionState.none:
                {
                  return FailedToGetDataView(
                    callback: () {
                      /* TODO: retry getting the data */
                    },
                  );
                }
              default:
                {
                  return ChooseChordView(
                    chords: chords.data!,
                  );
                }
            }
          }),
    );
  }
}

class ChooseChordView extends StatelessWidget {
  final List<Chord> chords;

  const ChooseChordView({Key? key, required this.chords}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var tiles = chords.map((chord) {
      return ChordListTile(
        chord: chord,
        onTap: (tappedChord) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChordView(
                chord: tappedChord,
              ),
            ),
          );
        },
      );
    });

    return ListView(
      scrollDirection: Axis.vertical,
      children: tiles.toList(),
    );
  }
}

class ChordListTile extends StatelessWidget {
  final Chord chord;
  final void Function(Chord) onTap;

  const ChordListTile({Key? key, required this.chord, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chord.name),
      subtitle: Text('Root: ${chord.root}'),
      onTap: () => onTap(chord),
      trailing: Icon(Icons.arrow_right_rounded),
    );
  }
}
