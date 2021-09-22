import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'package:chords/models/ChordCategory.dart';
import 'views/ChordCategoryDetailsView.dart';
import 'package:flutter/rendering.dart';
import 'views/LoadingView.dart';
import 'views/FailedToGetDataView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Chords Library'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<ChordCategory>> getCategories() async {
    await Firebase.initializeApp();
    return FirebaseFirestore.instance
        .collection('chord-categories')
        .get()
        .asStream()
        .map((event) => event.docs)
        .map(
          (events) => events.map(
            (event) {
              var data = event.data();
              return ChordCategory(
                chordsCollection: data['chordsCollection'] as String,
                id: data['id'] as String,
                name: data['name'] as String,
                description: data['description'] as String,
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
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: getCategories(),
          builder: (context, AsyncSnapshot<List<ChordCategory>> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return ChooseChordCategoryView(
                chordCategories: snapshot.data!,
              );
            } else if (snapshot.connectionState == ConnectionState.none) {
              return FailedToGetDataView(
                callback: () {
                  /* TODO: retry getting the data */
                },
              );
            } else {
              print(snapshot.data);
              return LoadingView();
            }
          },
        ));
  }
}

class ChooseChordCategoryView extends StatelessWidget {
  final List<ChordCategory> chordCategories;

  const ChooseChordCategoryView({Key? key, required this.chordCategories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var categoryViews = chordCategories.map((category) => ChordCategoryListTile(
          chordCategory: category,
          onTap: (selectedChordCategory) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChordCategoryDetailsView(
                  chordCategory: selectedChordCategory,
                ),
              ),
            );
          },
        ));

    return ListView(
      scrollDirection: Axis.vertical,
      children: categoryViews.toList(),
    );
  }
}

class ChordCategoryListTile extends StatelessWidget {
  final ChordCategory chordCategory;
  final void Function(ChordCategory) onTap;

  const ChordCategoryListTile(
      {Key? key, required this.chordCategory, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chordCategory.name),
      subtitle: Text(chordCategory.description),
      onTap: () => onTap(chordCategory),
      trailing: Icon(Icons.arrow_right),
    );
  }
}
