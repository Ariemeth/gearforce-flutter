import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';
import 'package:gearforce/screens/roster/text_cell.dart';

class CombatGroupTable extends StatefulWidget {
  CombatGroupTable(
    this.data,
    this.roster,
  );

  final Data data;
  final UnitRoster roster;

  @override
  _CombatGroupTableState createState() => _CombatGroupTableState();
}

class _CombatGroupTableState extends State<CombatGroupTable> {
  final List<Unit> _units = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        createUnitTable(bgColor: Colors.blue[200], units: this._units),
        Row(
          children: [
            SizedBox(
              child: FloatingActionButton(
                onPressed: () {
                  _navigateToUnitSelector(context);
                },
                child: const Icon(Icons.add_box_sharp),
                backgroundColor: Colors.green[600],
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
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnitSelector(
          title: "Unit Selector",
          data: this.widget.data,
          faction: this.widget.roster.faction.value,
        ),
      ),
    );

    if (result is Unit) {
      setState(() {
        this._units.add(result);
      });
    }
    //this.table.children.forEach((element) {
    //  print(element);
    //});
  }
}

Table createUnitTable({Color? bgColor: Colors.blue, List<Unit>? units}) {
  var t = Table(
    columnWidths: const <int, TableColumnWidth>{
      0: IntrinsicColumnWidth(),
      10: FlexColumnWidth(1.0),
    },
    children: <TableRow>[
      unitHeader(
        bgColor: bgColor,
      ),
    ],
  );

  //units.forEach((element) {
  //      return unitRow(element);
  //    })

  return t;
}

TableRow unitHeader({Color? bgColor: Colors.blue}) {
  return TableRow(children: [
    CGTextCell('Model Name', bgColor: bgColor),
    CGTextCell('TV', bgColor: bgColor),
    CGTextCell('UA', bgColor: bgColor),
    CGTextCell('MR', bgColor: bgColor),
    CGTextCell('AR', bgColor: bgColor),
    CGTextCell('H/S', bgColor: bgColor),
    CGTextCell('A', bgColor: bgColor),
    CGTextCell('GU', bgColor: bgColor),
    CGTextCell('PI', bgColor: bgColor),
    CGTextCell('EW', bgColor: bgColor),
    CGTextCell('Weapons', bgColor: bgColor),
    CGTextCell('Traits', bgColor: bgColor),
    CGTextCell('Type', bgColor: bgColor),
    CGTextCell('Height', bgColor: bgColor),
  ]);
}

TableRow unitRow(Unit unit, {Color? bgColor}) {
  return TableRow(children: [
    CGTextCell(unit.name, bgColor: bgColor),
    CGTextCell(unit.tv.toString(), bgColor: bgColor),
    CGTextCell(unit.ua.toString(), bgColor: bgColor),
    CGTextCell(unit.movement.toString(), bgColor: bgColor),
    CGTextCell(unit.armor.toString(), bgColor: bgColor),
    CGTextCell(unit.hull.toString() + '/' + unit.structure.toString(),
        bgColor: bgColor),
    CGTextCell(unit.actions.toString(), bgColor: bgColor),
    CGTextCell(unit.gunnery.toString() + '+', bgColor: bgColor),
    CGTextCell(unit.piloting.toString() + '+', bgColor: bgColor),
    CGTextCell(unit.ew.toString() + '+', bgColor: bgColor),
    CGTextCell(unit.weapons.toString(), bgColor: bgColor),
    CGTextCell(unit.traits.toString(), bgColor: bgColor),
    CGTextCell(unit.type, bgColor: bgColor),
    CGTextCell(unit.height, bgColor: bgColor),
  ]);
}
