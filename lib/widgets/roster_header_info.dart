import 'package:flutter/material.dart';
import 'package:gearforce/widgets/select_faction.dart';
import 'package:gearforce/widgets/select_subfaction.dart';

class RosterHeaderInfo extends StatelessWidget {
  const RosterHeaderInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const <int, TableColumnWidth>{
        0: IntrinsicColumnWidth(),
        2: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
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
              ),
              scrollPadding: EdgeInsets.all(0.0),
              style: TextStyle(fontSize: 16),
              strutStyle: StrutStyle(),
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
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
              ),
              scrollPadding: EdgeInsets.all(0.0),
            ),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: Text(
              'Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: SelectFaction(),
          ),
          Container(),
        ]),
        TableRow(children: [
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: Text(
              'Sub-Faction:',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10, left: 5, top: 5, bottom: 5),
            child: SelectSubFaction(),
          ),
          Container(),
        ]),
      ],
    );
  }
}
