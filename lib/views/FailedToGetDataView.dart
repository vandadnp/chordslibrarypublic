import 'package:flutter/material.dart';

class FailedToGetDataView extends StatelessWidget {
  final VoidCallback callback;

  const FailedToGetDataView({Key? key, required this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cold not load any data'),
          SizedBox(
            height: 12,
          ),
          TextButton(
            onPressed: callback,
            child: Text('Try again'),
          ),
        ],
      ),
    );
  }
}
