import 'package:chords/models/Chord.dart';
import 'package:chords/models/ChordVariation.dart';
import 'package:chords/views/LoadingView.dart';
import 'package:chords/views/ChordVariationView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'FailedToGetDataView.dart';

class ChordView extends StatefulWidget {
  final Chord chord;

  const ChordView({Key? key, required this.chord}) : super(key: key);
  @override
  _ChordViewState createState() => _ChordViewState();
}

class _ChordViewState extends State<ChordView> {
  Future<List<Widget>> getChordWidgets() {
    return FirebaseFirestore.instance
        .collection(widget.chord.variationsPath)
        .get()
        .asStream()
        .map((event) => event.docs)
        .map(
          (docs) => docs.map(
            (doc) {
              final data = doc.data();
              // print(data);
              final variation = ChordVariation.fromJson(data);
              final view = ChordVariationView(
                chordVariation: variation,
              );
              return view;
            },
          ).toList(),
        )
        .firstWhere((element) => element.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chord.name),
      ),
      body: FutureBuilder(
        builder: (context, AsyncSnapshot<List<Widget>> chordWidgets) {
          if (chordWidgets.connectionState == ConnectionState.waiting) {
            return LoadingView();
          } else if (chordWidgets.connectionState == ConnectionState.none) {
            return FailedToGetDataView(
              callback: () {
                /* TODO: retry getting the data */
              },
            );
          } else {
            return ChordDetailsView(
              widgets: chordWidgets.data!,
            );
          }
        },
        future: getChordWidgets(),
      ),
    );
  }
}

class ChordDetailsView extends StatelessWidget {
  final List<Widget> widgets;

  const ChordDetailsView({Key? key, required this.widgets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: widgets,
    );
  }
}
