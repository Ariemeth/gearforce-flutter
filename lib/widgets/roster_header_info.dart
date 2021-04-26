import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/widgets/select_faction.dart';
import 'package:gearforce/widgets/select_subfaction.dart';

class RosterHeaderInfo extends StatelessWidget {
  RosterHeaderInfo({Key? key, required this.dataBundle, required this.roster})
      : super(key: key);

  final UnitRoster roster;
  final Data dataBundle;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        1: FixedColumnWidth(300.0),
        2: FlexColumnWidth(1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Player name:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
              ),
              onChanged: (String value) async {
                roster.player = value;
              },
              onSubmitted: (String value) async {
                // DEBUG use playername onSubmit to print the roster.
                print(roster);
              },
              style: TextStyle(fontSize: 16),
              strutStyle: StrutStyle.disabled,
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Force name:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 5,
                ),
              ),
              onChanged: (String value) async {
                roster.name = value;
              },
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: SelectFaction(
              factions: dataBundle.factions(),
              selectedFaction: this.roster.faction,
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 5, left: 5, top: 5, bottom: 5),
            child: Text(
              'Sub-Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: SelectSubFaction(
              factions: dataBundle.factions(),
              selectedFaction: this.roster.faction,
              selectedSubFaction: this.roster.subFaction,
            ),
          ),
          Container(),
        ]),
      ],
    );
  }
}
