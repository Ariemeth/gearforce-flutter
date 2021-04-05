import 'package:flutter/material.dart';

class Roster extends StatefulWidget {
  Roster({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _RosterState createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the Roster object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title!),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: Text(
              'blah test',
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }
}
