import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/mods/duelist/duelist_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:gearforce/screens/roster/group_header.dart';
import 'package:gearforce/screens/upgrades/upgrades_dialog.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:provider/provider.dart';

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
        GroupHeader(
          cg: widget.getOwnCG(),
          isPrimary: true,
        ),
        Expanded(
          child: _generateTable(
            context: context,
            group: widget.getOwnCG().primary,
            isPrimary: true,
          ),
        ),
        GroupHeader(
          cg: widget.getOwnCG(),
          isPrimary: false,
        ),
        Expanded(
          child: _generateTable(
            context: context,
            group: widget.getOwnCG().secondary,
            isPrimary: false,
          ),
        ),
      ],
    );
  }

  Widget _generateTable({
    required BuildContext context,
    required Group group,
    required bool isPrimary,
  }) {
    var table = DataTable(
      columns: _generateTableHeading(),
      rows: _generateTableRows(context: context, group: group),
      columnSpacing: 2.0,
      horizontalMargin: 0.0,
      headingRowHeight: 30.0,
      headingRowColor: MaterialStateColor.resolveWith(
        (states) => Color.fromARGB(255, 187, 222, 251),
      ),
    );

    var target = DragTarget(
      builder: (
        BuildContext context,
        List<Object?> candidateData,
        List<dynamic> rejectedData,
      ) {
        return SingleChildScrollView(child: table);
      },
      onAccept: (UnitCore uc) {
        setState(() {
          group.addUnit(uc);
        });
      },
      onWillAccept: (UnitCore? uc) {
        var r = uc!.role;
        return r == null ||
            r.includesRole([RoleType.Upgrade]) ||
            r.includesRole([group.role()]);
      },
    );

    return target;
  }

  List<DataColumn> _generateTableHeading() {
    return <DataColumn>[
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
          width: 75,
          child: UnitTextCell.columnTitle(
            'Upgrades',
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
    ];
  }

  List<DataRow> _generateTableRows({
    required BuildContext context,
    required Group group,
  }) {
    List<DataRow> dataRows = [];
    var units = group.allUnits();
    for (var i = 0; i < units.length; i++) {
      var unit = units[i];
      var canNotBeCommand = unit.core.type == 'Airstrike Counter' ||
          unit.core.type == 'Drone' ||
          unit.core.type == 'Building' ||
          unit.traits.any((element) => element.name == 'Conscript');
      var nameCell = DataCell(UnitTextCell.content(
        unit.attribute(UnitAttribute.name),
        alignment: Alignment.centerLeft,
        textAlignment: TextAlign.left,
      ));

      var tvCell = DataCell(UnitTextCell.content(unit.tv.toString()));

      var actionCell = DataCell(UnitTextCell.content(
          unit.attribute(UnitAttribute.actions) == null
              ? '-'
              : unit.attribute(UnitAttribute.actions).toString()));
      var commandCell = DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: Center(
                  child: DropdownButton<String>(
                    value: canNotBeCommand
                        ? null
                        : commandLevelString(unit.commandLevel),
                    hint: Text('Select Command Level'),
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 16,
                    elevation: 16,
                    isExpanded: true,
                    isDense: true,
                    style: const TextStyle(color: Colors.blue),
                    underline: SizedBox(),
                    onChanged: (String? newValue) {
                      setState(() {
                        unit.commandLevel = newValue == null
                            ? CommandLevel.none
                            : convertToCommand(newValue);
                      });
                    },
                    items: canNotBeCommand
                        ? null
                        : CommandLevel.values.where((element) {
                            if (unit.hasMod(independentOperatorId) &&
                                (element == CommandLevel.cgl ||
                                    element == CommandLevel.secic)) {
                              return false;
                            }
                            return true;
                          }).map<DropdownMenuItem<String>>(
                            (CommandLevel value) {
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
      ));
      var duelistCell = DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: Radio<bool>(
                value: unit.isDuelist,
                groupValue: true,
                toggleable: true,
                onChanged: (bool? value) {},
              ),
            ),
          ),
        ],
      ));
      var veteranCell = DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              child: Radio<bool>(
                value: unit.isVeteran(),
                toggleable: true,
                groupValue: true,
                onChanged: (bool? value) {},
              ),
            ),
          ),
        ],
      ));
      var upgradeCell = DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: IconButton(
                  onPressed: () => {
                    _showUpgradeDialog(context, unit, i, group, widget.roster)
                  },
                  icon: const Icon(
                    Icons.add_task,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
      var removeCell = DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                child: IconButton(
                  onPressed: () =>
                      {_showConfirmDelete(context, unit, i, group)},
                  icon: const Icon(
                    Icons.delete_forever,
                    color: Color.fromARGB(255, 200, 28, 28),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

      var dataRow = DataRow(cells: [
        nameCell,
        tvCell,
        actionCell,
        commandCell,
        duelistCell,
        veteranCell,
        upgradeCell,
        removeCell
      ]);
      dataRows.add(dataRow);
    }

    return dataRows;
  }

  void _showUpgradeDialog(
    BuildContext context,
    Unit unit,
    int unitIndex,
    Group group,
    UnitRoster roster,
  ) {
    /*Future<OptionResult?> futureResult =*/
    var result = showDialog<OptionResult>(
        context: context,
        builder: (BuildContext context) {
          return ChangeNotifierProvider.value(
            value: unit,
            child: UpgradesDialog(
              roster: roster,
              cg: widget.getOwnCG(),
              unit: unit,
            ),
          );
        });

    result.whenComplete(() {
      setState(() {});
      if (!kReleaseMode) {
        print('unit weapons after returning from upgrade screen');
        print('react weapons: ${unit.reactWeapons.toString()}');
        print('mount weapons: ${unit.mountedWeapons.toString()}');
        print('       traits: ${unit.traits.toString()}');
        print('      actions: ${unit.actions}');
      }
    });

    /* futureResult.then((value) {
      switch (value) {
        case OptionResult.Remove:
          setState(() {
            group.removeUnit(unitIndex);
          });
          break;
        default:
      }
    });
    */
  }

  void _showConfirmDelete(
    BuildContext context,
    Unit unit,
    int unitIndex,
    Group group,
  ) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Column(
        children: [
          Text(
            'Are you sure you want to remove',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            '${unit.attribute(UnitAttribute.name)}?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
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
            group.removeUnit(unitIndex);
          });
          break;
        default:
      }
    });
  }
}

enum OptionResult { Remove, Cancel, Upgrade }
