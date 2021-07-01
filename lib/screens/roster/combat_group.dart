import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/screens/roster/select_role.dart';
import 'package:gearforce/screens/unitSelector/unit_selector.dart';
import 'package:gearforce/widgets/display_value.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

const _numColumns = 6;
const _maxPrimaryActions = 6;
const _minPrimaryActions = 4;

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
    widget.roster.setActiveCG(widget.name);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _generateGroupHeader(
          context: context,
          group: widget.getOwnCG().primary,
          isPrimary: true,
        ),
        Expanded(
          child: _generateTable2(
            context: context,
            group: widget.getOwnCG().primary,
            isPrimary: true,
          ),
        ),
        _generateGroupHeader(
          context: context,
          group: widget.getOwnCG().secondary,
          isPrimary: false,
        ),
        Flexible(
          child: _generateTable(
            context: context,
            group: widget.getOwnCG().secondary,
            isPrimary: false,
          ),
        ),
      ],
    );
  }

  // ignore: unused_element
  _navigateToUnitSelector(
    BuildContext context,
    RoleType? role, {
    required bool isPrimary,
  }) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UnitSelector(),
      ),
    );

    if (result is UnitCore) {
      this._addUnit(result, isPrimary: isPrimary);
    }
  }

  Widget _generateGroupHeader({
    required BuildContext context,
    required Group group,
    bool isPrimary = true,
  }) {
    String groupType = isPrimary ? 'Primary' : 'Secondary';
    final actions = group.totalActions();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
              group: group,
            ),
            width: 75,
          ),
          SizedBox(
            width: 20,
          ),
          DisplayValue(text: 'TV:', value: group.totalTV()),
          Tooltip(
            message: isPrimary
                // a cg is only valid if the number of actions is greater then 4 and
                // less then or equal to 6
                ? actions > _maxPrimaryActions || actions < _minPrimaryActions
                    ? 'too many or too few actions'
                    : 'valid number of actions'
                : actions >
                        (widget.getOwnCG().primary.totalActions() / 2).ceil()
                    ? 'too many actions or too few actions'
                    : 'valid number of actions',
            child: DisplayValue(
              text: 'Actions',
              value: actions,
              textColor: isPrimary
                  // a cg is only valid if the number of actions is greater then 4 and
                  // less then or equal to 6
                  ? actions > _maxPrimaryActions || actions < _minPrimaryActions
                      ? Colors.red
                      : Colors.green
                  : actions >
                          (widget.getOwnCG().primary.totalActions() / 2).ceil()
                      ? Colors.red
                      : Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateTable2({
    required BuildContext context,
    required Group group,
    required bool isPrimary,
  }) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Container(
            alignment: Alignment.centerLeft,
            width: 160,
            child: UnitTextCell.columnTitle(
              "Model",
              textAlignment: TextAlign.left,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: 50,
            child: UnitTextCell.columnTitle(
              'TV',
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: 60,
            child: UnitTextCell.columnTitle(
              'Actions',
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: 120,
            child: UnitTextCell.columnTitle(
              'Command type',
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: 65,
            child: UnitTextCell.columnTitle(
              'Duelist',
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: 65,
            child: UnitTextCell.columnTitle(
              'Veteran',
            ),
          ),
        ),
        DataColumn(
          label: Container(
            width: 65,
            child: UnitTextCell.columnTitle(
              'Remove',
            ),
          ),
        ),
      ],
      rows: <DataRow>[],
      columnSpacing: 2.0,
      horizontalMargin: 0.0,
      headingRowHeight: 30.0,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Color.fromARGB(255, 187, 222, 251),
      ),
    );
  }

  Widget _generateTable({
    required BuildContext context,
    required Group group,
    required bool isPrimary,
  }) {
    final units = group.allUnits();
    var table = StickyHeadersTable(
      legendCell: UnitTextCell.columnTitle(
        "Model Name",
        backgroundColor: Colors.blue[100],
        textAlignment: TextAlign.left,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      ),
      columnsLength: _numColumns,
      rowsLength: units.length,
      columnsTitleBuilder: _buildColumnTitles,
      rowsTitleBuilder: _buildRowTitles(units),
      contentCellBuilder: _buildCellContent(context, units, isPrimary),
      cellDimensions: CellDimensions.variableColumnWidth(
          columnWidths: [
            50.0, // TV
            60.0, // Actions
            120.0, // Command type
            65.0, // Duelist
            65.0, // Vet
            65.0, // Delete
          ],
          contentCellHeight: 50.0,
          stickyLegendWidth: 160.0,
          stickyLegendHeight: 50.0),
    );

    var target = DragTarget(
      builder: (
        BuildContext context,
        List<Object?> candidateData,
        List<dynamic> rejectedData,
      ) {
        return table;
      },
      onAccept: (UnitCore uc) {
        setState(() {
          group.addUnit(uc);
        });
      },
      onWillAccept: (UnitCore? uc) {
        return uc!.role!.includesRole([group.role()]);
      },
    );

    return target;
  }

  Widget _buildColumnTitles(int i) {
    return _buildUnitTitleCell(i);
  }

  Widget Function(int) _buildRowTitles(List<Unit> units) {
    return (int i) {
      return UnitTextCell.content(
        units[i].attribute(UnitAttribute.name),
        backgroundColor: ((i + 1) % 2 == 0) ? Colors.blue[100] : null,
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      );
    };
  }

  Widget Function(int, int) _buildCellContent(
    BuildContext context,
    List<Unit> units,
    bool isPrimary,
  ) {
    return (int i, int j) {
      Unit unit = units[j];
      return _buildUnitCell(context, i, j, unit, isPrimary);
    };
  }

  void _addUnit(UnitCore unit, {required bool isPrimary}) {
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

  void _showConfirmDelete(
    BuildContext context,
    Unit unit,
    int unitIndex,
    bool isPrimary,
  ) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Text(
        'Are you sure you want to delete ${unit.attribute(UnitAttribute.name)}?',
        style: TextStyle(fontSize: 24),
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Remove);
          },
          child: Center(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.Cancel);
          },
          child: Center(
            child: Text(
              'No',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
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

  Widget _buildUnitCell(
    BuildContext context,
    int column,
    int row,
    Unit unit,
    bool isPrimary,
  ) {
    String text = '';

    switch (column) {
      case 0:
        // TV
        text = unit.tv().toString();
        return UnitTextCell.content(
          text,
          backgroundColor: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
        );

      case 1:
        // Actions
        text = unit.attribute(UnitAttribute.actions).toString();
        return UnitTextCell.content(
          text,
          backgroundColor: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                  child: Center(
                    child: DropdownButton<String>(
                      value: commandLevelString(unit.commandLevel()),
                      hint: Text('Select faction'),
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 16,
                      elevation: 16,
                      isExpanded: true,
                      isDense: true,
                      style: const TextStyle(color: Colors.blue),
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          unit.makeCommand(newValue == null
                              ? CommandLevel.none
                              : convertToCommand(newValue));
                        });
                      },
                      items: CommandLevel.values
                          .map<DropdownMenuItem<String>>((CommandLevel value) {
                        return DropdownMenuItem<String>(
                          value: commandLevelString(value),
                          child: Center(
                            child: Text(
                              commandLevelString(value),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: Radio<bool>(
                    value: false,
                    groupValue: true,
                    toggleable: true,
                    onChanged: (bool? value) {
                      setState(() {
                        // TODO add actual state and set value on the unit
                      });
                    }),
                decoration: BoxDecoration(
                  color: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
                ),
              ),
            ),
          ],
        );
      case 4:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: Radio<bool>(
                    value: unit.isVeteran(),
                    toggleable: true,
                    groupValue: true,
                    onChanged: (bool? value) {
                      setState(() {
                        // TODO add actual state and set value on the unit
                      });
                    }),
                decoration: BoxDecoration(
                  color: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
                ),
              ),
            ),
          ],
        );
      case 5:
        // delete
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: IconButton(
                  onPressed: () =>
                      {_showConfirmDelete(context, unit, row, isPrimary)},
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 200, 28, 28),
                  ),
                ),
                decoration: BoxDecoration(
                  color: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
                ),
              ),
            ),
          ],
        );
    }
    return UnitTextCell.content(
      text,
      backgroundColor: ((row + 1) % 2 == 0) ? Colors.blue[100] : null,
    );
  }
}

enum OptionResult { Remove, Cancel, Upgrade }

Widget _buildUnitTitleCell(int i) {
  String text = "";
  switch (i) {
    case 0:
      // TV
      text = 'TV';
      break;
    case 1:
      // Actions
      text = 'Actions';
      break;
    case 2:
      // command options
      text = 'Command type';
      break;
    case 3:
      // duelist option
      text = 'Duelist';
      break;
    case 4:
      // veteran option
      text = 'Veteran';
      break;
    case 5:
      // delete
      text = 'Remove';
      break;
  }
  return UnitTextCell.columnTitle(
    text,
    backgroundColor: Colors.blue[100],
    padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
  );
}
