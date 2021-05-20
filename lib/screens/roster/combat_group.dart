import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/roster/combat_group_tv.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

const _numColumns = 14;

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
          _generateGroupHeader(group: widget.getOwnCG().primary),
          Expanded(child: _generateTable(widget.getOwnCG().primary.units)),
          Row(
            children: [
              SizedBox(
                child: FloatingActionButton(
                  heroTag: 'primary',
                  onPressed: () {
                    _navigateToUnitSelector(
                      context,
                      widget.getOwnCG().primary.role.value,
                      isPrimary: true,
                    );
                  },
                  child: const Icon(Icons.add_box_sharp),
                  backgroundColor: Colors.green[600],
                ),
                height: 40,
                width: 40,
              ),
            ],
          ),
          _generateGroupHeader(
            group: widget.getOwnCG().secondary,
            isPrimary: false,
          ),
          Expanded(child: _generateTable(widget.getOwnCG().secondary.units)),
          Row(
            children: [
              SizedBox(
                child: FloatingActionButton(
                  heroTag: 'secondary',
                  onPressed: () {
                    _navigateToUnitSelector(
                      context,
                      widget.getOwnCG().secondary.role.value,
                      isPrimary: false,
                    );
                  },
                  child: const Icon(Icons.add_box_sharp),
                  backgroundColor: Colors.green[600],
                ),
                height: 40,
                width: 40,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _navigateToUnitSelector(
    BuildContext context,
    RoleType? role, {
    required bool isPrimary,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnitSelector(
          title: "Unit Selector",
          data: this.widget.data,
          faction: this.widget.roster.faction.value,
          role: role,
        ),
      ),
    );

    if (result is Unit) {
      this._addUnit(result, isPrimary: isPrimary);
    }
  }

  Widget _generateGroupHeader({
    required Group group,
    bool isPrimary = true,
  }) {
    String groupType = isPrimary ? 'Primary' : 'Secondary';
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
                  '$groupType Combat Group',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
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
                    selectedRole: group.role,
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
                  child: CombatGroupTVTotal(totalTV: group.totalTV()),
                ),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _generateTable(List<Unit> units) {
    var table = StickyHeadersTable(
      legendCell: UnitTextCell.columnTitle(
        "Model Name",
        backgroundColor: Colors.blue[100],
        textAlignment: TextAlign.left,
      ),
      columnsLength: _numColumns,
      rowsLength: units.length,
      columnsTitleBuilder: _buildColumnTitles,
      rowsTitleBuilder: _buildRowTitles(units),
      contentCellBuilder: _buildCellContent(units),
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

  void _addUnit(Unit unit, {required bool isPrimary}) {
    setState(() {
      if (isPrimary) {
        widget.getOwnCG().primary.units.add(unit);
      } else {
        widget.getOwnCG().secondary.units.add(unit);
      }
    });
  }

  int totalTV() {
    return widget.getOwnCG().totalTV();
  }
}
