import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';
import 'package:gearforce/widgets/text_cell.dart';

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
    CGTextCell(
      'Model Name',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'TV',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'UA',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'MR',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'AR',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'H/S',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'A',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'GU',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'PI',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'EW',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'Weapons',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'Traits',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'Type',
      backgroundColor: backgroundColor,
    ),
    CGTextCell(
      'Height',
      backgroundColor: backgroundColor,
    ),
  ]);
}
