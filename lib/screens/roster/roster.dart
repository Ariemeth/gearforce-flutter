import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/widgets/combat_groups.dart';
import 'package:gearforce/widgets/roster_header_info.dart';

class RosterWidget extends StatefulWidget {
  RosterWidget({
    Key? key,
    required this.title,
    required this.data,
  }) : super(key: key);

  final String? title;
  final Data data;

  @override
  _RosterWidgetState createState() => _RosterWidgetState();
}

class _RosterWidgetState extends State<RosterWidget> {
  final UnitRoster roster = UnitRoster();

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            RosterHeaderInfo(
              dataBundle: widget.data,
              roster: this.roster,
            ),
            Container(
              child: CombatGroupTable(widget.data, this.roster),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ),
      ),
    );
  }
}
