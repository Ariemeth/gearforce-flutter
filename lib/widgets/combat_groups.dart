import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';

class CombatGroupTable extends StatelessWidget {
  const CombatGroupTable(
    this.data,
    this.roster,
  );

  final Data data;
  final UnitRoster roster;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        createUnitTable(
          backgroundColor: Colors.blue[200],
        ),
        Row(
          children: [
            SizedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _navigateToUnitSelector(context);
                },
                child: const Icon(Icons.add_box_sharp),
                backgroundColor: Colors.green[300],
              ),
              height: 40,
              width: 40,
            ),
          ],
        )
      ],
    );
  }

  _navigateToUnitSelector(BuildContext context) async {
    // TODO get returns models and add to the group
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnitSelector(
          title: "Unit Selector",
          data: this.data,
          faction: this.roster.faction.value,
        ),
      ),
    );
  }
}

Table createUnitTable({Color? backgroundColor: Colors.blue}) {
  return Table(
    columnWidths: const <int, TableColumnWidth>{
      0: IntrinsicColumnWidth(),
      10: FlexColumnWidth(1.0),
    },
    children: <TableRow>[
      unitHeader(
        backgroundColor: backgroundColor,
      ),
    ],
  );
}

TableRow unitHeader({Color? backgroundColor: Colors.blue}) {
  return TableRow(children: [
    CGCell(
      'Model Name',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'TV',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'UA',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'MR',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'AR',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'H/S',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'A',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'GU',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'PI',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'EW',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'Weapons',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'Traits',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'Type',
      backgroundColor: backgroundColor,
    ),
    CGCell(
      'Height',
      backgroundColor: backgroundColor,
    ),
  ]);
}

class CGCell extends StatelessWidget {
  const CGCell(this.text,
      {this.textAlignment = TextAlign.center, this.backgroundColor});

  final String text;
  final TextAlign textAlignment;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: this.backgroundColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(5),
        child: Text(
          this.text,
          textAlign: this.textAlignment,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
