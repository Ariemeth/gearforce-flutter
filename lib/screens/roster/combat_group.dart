import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

const _numColumns = 14;

class CombatGroupWidget extends StatefulWidget {
  CombatGroupWidget(this.data, this.roster, {required this.name});

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
    return Column(
      children: [
        _generateGroupHeader(
          group: widget.getOwnCG().primary,
          isPrimary: true,
        ),
        Expanded(
          child: _generateTable(
            context,
            widget.getOwnCG().primary.allUnits(),
            true,
          ),
        ),
        _generateGroupHeader(
          group: widget.getOwnCG().secondary,
          isPrimary: false,
        ),
        Expanded(
          child: _generateTable(
            context,
            widget.getOwnCG().secondary.allUnits(),
            false,
          ),
        ),
      ],
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
                SizedBox(
                  width: 85,
                  child: Text(
                    groupType,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Role: ",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  child: SelectRole(
                    selectedRole: group.role,
                  ),
                  width: 75,
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 75,
                  child: OutlinedButton(
                    onPressed: () {
                      _navigateToUnitSelector(
                        context,
                        isPrimary
                            ? widget.getOwnCG().primary.role.value
                            : widget.getOwnCG().secondary.role.value,
                        isPrimary: isPrimary,
                      );
                    },
                    child: const Text('Add Unit'),
                  ),
                ),
                Expanded(child: Container()),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _generateTable(
    BuildContext context,
    List<Unit> units,
    bool isPrimary,
  ) {
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
      onContentCellPressed: _contentPressed(context, units, isPrimary),
      onRowTitlePressed: _rowTitlePressed(context, units, isPrimary),
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

  dynamic Function(int, int) _contentPressed(
    BuildContext context,
    List<Unit> units,
    bool isPrimary,
  ) {
    return (int i, int j) {
      _showUnitOptionsDialog(context, units[j], j, isPrimary);
    };
  }

  dynamic Function(int) _rowTitlePressed(
    BuildContext context,
    List<Unit> units,
    bool isPrimary,
  ) {
    return (int i) {
      _showUnitOptionsDialog(
        context,
        units[i],
        i,
        isPrimary,
      );
    };
  }

  void _addUnit(Unit unit, {required bool isPrimary}) {
    setState(() {
      if (isPrimary) {
        widget.getOwnCG().primary.addUnit(unit);
      } else {
        widget.getOwnCG().secondary.addUnit(unit);
      }
    });
  }

  int totalTV() {
    return widget.getOwnCG().totalTV();
  }

  void _showUnitOptionsDialog(
    BuildContext context,
    Unit unit,
    int unitIndex,
    bool isPrimary,
  ) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Text(
        'Unit options',
        style: TextStyle(fontSize: 24),
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Remove);
          },
          child: Text(
            'Remove Unit',
            style: TextStyle(fontSize: 24, color: Colors.red),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Upgrade);
          },
          child: Text(
            'Add upgrade',
            style: TextStyle(fontSize: 24, color: Colors.green),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Cancel);
          },
          child: Text(
            'Cancel',
            style: TextStyle(fontSize: 24, color: Colors.grey),
          ),
        ),
      ],
    );

    Future<OptionResult?> futureResult = showDialog<OptionResult>(
        context: context,
        builder: (BuildContext context) {
          return optionsDialog;
        });

    futureResult.then((value) {
      switch (value) {
        case OptionResult.Remove:
          setState(() {
            isPrimary
                ? widget.getOwnCG().primary.removeUnit(unitIndex)
                : widget.getOwnCG().secondary.removeUnit(unitIndex);
          });
          break;
        default:
      }
    });
  }
}

enum OptionResult { Remove, Cancel, Upgrade }
