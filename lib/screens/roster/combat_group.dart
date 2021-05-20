import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/roster/combat_group_tv.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class CombatGroupWidget extends StatefulWidget {
  CombatGroupWidget(this.data, this.roster, {required this.name}) {
    if (roster.getCG(name) == null) {
      roster.addCG(CombatGroup(name));
    }
  }

  final Data data;
  final UnitRoster roster;
  final String name;

  CombatGroup getOwnCG() {
    var cg = this.roster.getCG(this.name);
    if (cg == null) {
      cg = CombatGroup(this.name);
    }
    return cg;
  }

  @override
  _CombatGroupWidgetState createState() => _CombatGroupWidgetState();
}

class _CombatGroupWidgetState extends State<CombatGroupWidget> {
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      child: Column(
        children: [
          Flexible(
            child: _generateHeader(),
            flex: 0,
          ),
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
          role: widget.getOwnCG().primary.role.value,
        ),
      ),
    );

    if (result is Unit) {
      this._addUnit(result);
    }
  }

  Widget _generateHeader() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  "Role: ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  child: SelectRole(
                    selectedRole: widget.getOwnCG().primary.role,
                  ),
                  width: 100,
                ),
                SizedBox(
                  width: 25,
                ),
                Text(
                  'Combatgroup TV: ',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 50,
                  child: CombatGroupTVTotal(totalTV: totalTV()),
                ),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _generateTable() {
    var cg = widget.getOwnCG();
    var table = StickyHeadersTable(
      legendCell: UnitTextCell.columnTitle(
        "Model Name",
        backgroundColor: Colors.blue[100],
        textAlignment: TextAlign.left,
      ),
      // TODO: look into way to not have to manually set this everywhere
      columnsLength: 14,
      rowsLength: cg.primary.units.length,
      columnsTitleBuilder: _buildColumnTitles,
      rowsTitleBuilder: _buildRowTitles(cg.primary.units),
      contentCellBuilder: _buildCellContent(cg.primary.units),
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

  void _addUnit(Unit unit) {
    setState(() {
      widget.getOwnCG().primary.units.add(unit);
    });
  }

  int totalTV() {
    return widget.getOwnCG().totalTV();
  }
}
