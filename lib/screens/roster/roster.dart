import 'package:flutter/material.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/roster/combat_groups_display.dart';
import 'package:gearforce/screens/roster/roster_header_info.dart';
import 'package:gearforce/screens/unitSelector/unit_selection.dart';
import 'package:provider/provider.dart';

const double _leftPanelWidth = 670.0;

class RosterWidget extends StatefulWidget {
  RosterWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String? title;

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
      body: ChangeNotifierProvider(
        create: (_) => roster,
        child: Row(
          children: [
            SizedBox(
              width: _leftPanelWidth,
              child: Column(
                children: [
                  RosterHeaderInfo(),
                  CombatGroupsDisplay(),
                ],
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),
            ),
            Expanded(
              child: UnitSelection(),
              flex: 2,
            ),
          ],
        ),
      ),
    );
  }
}
