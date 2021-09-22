import 'package:chords/models/ChordVariation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChordVideoView extends StatelessWidget {
  final ChordVariation chordVariation;
  final _key = UniqueKey();

  ChordVideoView({required this.chordVariation});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 232.0,
      child: WebView(
        key: _key,
        initialUrl: chordVariation.embedVideoUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
