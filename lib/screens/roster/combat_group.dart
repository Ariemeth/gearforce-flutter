import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';

import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class CombatGroup extends StatefulWidget {
  CombatGroup(
    this.data,
    this.roster,
  );

  final Data data;
  final UnitRoster roster;
  final List<Unit> _units = [];

  @override
  _CombatGroupState createState() => _CombatGroupState();
}

class _CombatGroupState extends State<CombatGroup> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Column(
        children: [
          Flexible(
            child: _generateTable(),
            flex: 1,
          ),
          Flexible(
            flex: 0,
            child: Row(
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
            ),
          ),
        ],
      ),
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
        widget._units.add(result);
      });
    }
  }

  Widget _generateTable() {
    var table = StickyHeadersTable(
      legendCell: UnitTextCell.columnTitle(
        "Model Name",
        backgroundColor: Colors.blue[100],
        textAlignment: TextAlign.left,
      ),
      columnsLength: 12,
      rowsLength: widget._units.length,
      columnsTitleBuilder: _buildColumnTitles,
      rowsTitleBuilder: _buildRowTitles(widget._units),
      contentCellBuilder: _buildCellContent(widget._units),
      onContentCellPressed: _contentPressed(),
      onRowTitlePressed: _rowTitlePressed(),
    );
    return table;
  }

  Widget _buildColumnTitles(int i) {
    return buildUnitTitleCell(i);
  }

  Widget Function(int) _buildRowTitles(List<Unit> units) {
    return (int i) {
      return UnitTextCell.content(
        units[i].name,
        backgroundColor: ((i + 1) % 2 == 0) ? Colors.blue[100] : null,
      );
    };
  }

  Widget Function(int, int) _buildCellContent(List<Unit> units) {
    return (int i, int j) {
      Unit unit = units[j];
      return buildUnitCell(i, j, unit);
    };
  }

  dynamic Function(int, int) _contentPressed() {
    return (int i, int j) {};
  }

  dynamic Function(int) _rowTitlePressed() {
    return (int i) {};
  }
}
