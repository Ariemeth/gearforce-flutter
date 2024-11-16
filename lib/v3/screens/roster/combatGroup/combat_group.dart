import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/screens/roster/combatGroup/group_header.dart';
import 'package:gearforce/v3/screens/upgrades/unit_upgrade_button.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:gearforce/widgets/unit_text_cell.dart';
import 'package:provider/provider.dart';

const double _sectionheight = 320;
const double _movementIconCellWidth = 36;

class CombatGroupWidget extends StatefulWidget {
  const CombatGroupWidget(this.roster, {super.key, required this.name});

  final UnitRoster roster;
  final String name;

  CombatGroup getOwnCG() {
    var cg = roster.getCG(name);
    cg ??= CombatGroup(name);
    return cg;
  }

  @override
  State<CombatGroupWidget> createState() => _CombatGroupWidgetState();
}

class _CombatGroupWidgetState extends State<CombatGroupWidget> {
  @override
  Widget build(BuildContext context) {
    final cg = widget.getOwnCG();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroupHeader(
          cg: cg,
          group: cg.primary,
          roster: widget.roster,
        ),
        Container(
          constraints: const BoxConstraints(minHeight: _sectionheight / 2),
          child: _generateTable(
            context: context,
            group: cg.primary,
            cg: cg,
            ruleSet: widget.roster.rulesetNotifer.value,
          ),
        ),
        GroupHeader(
          cg: cg,
          group: cg.secondary,
          roster: widget.roster,
        ),
        Container(
          constraints: const BoxConstraints(minHeight: _sectionheight / 2),
          child: _generateTable(
            context: context,
            group: cg.secondary,
            cg: cg,
            ruleSet: widget.roster.rulesetNotifer.value,
          ),
        ),
      ],
    );
  }

  Widget _generateTable({
    required BuildContext context,
    required Group group,
    required CombatGroup cg,
    required RuleSet ruleSet,
  }) {
    var table = DataTable(
      columns: _generateTableHeading(),
      rows: _generateTableRows(
        context: context,
        group: group,
        ruleSet: widget.roster.rulesetNotifer.value,
      ),
      columnSpacing: 1.0,
      horizontalMargin: 0.0,
      headingRowHeight: 30.0,
      headingRowColor: WidgetStateColor.resolveWith(
        (states) => Theme.of(context).primaryColorLight,
      ),
    );

    var target = DragTarget(
      builder: (
        BuildContext context,
        List<Object?> candidateData,
        List<dynamic> rejectedData,
      ) {
        return table;
      },
      onAcceptWithDetails: (DragTargetDetails<Unit>? details) {
        if (details == null) {
          return;
        }

        group.addUnit(Unit.from(details.data));
      },
      onWillAcceptWithDetails: (DragTargetDetails<Unit>? details) {
        if (details == null) {
          return false;
        }

        final u = details.data;
        final canBeAddedValidations = ruleSet.canBeAddedToGroup(u, group, cg);

        final canBeAdded = canBeAddedValidations.isValid();

        if (!canBeAdded) {
          final snack = SnackBar(
              content: Text(
                  '${u.name} can not be added to the ${group.groupType.name} group; reason: ${canBeAddedValidations.toString()}'));
          ScaffoldMessenger.of(context).showSnackBar(snack);
        }
        return canBeAdded;
      },
    );

    return target;
  }

  List<DataColumn> _generateTableHeading() {
    return <DataColumn>[
      const DataColumn(
        label: SizedBox(
          width: _movementIconCellWidth,
          child: UnitTextCell.columnTitle(
            '',
          ),
        ),
      ),
      DataColumn(
        label: Container(
          alignment: Alignment.centerLeft,
          width: 180,
          child: const UnitTextCell.columnTitle(
            'Model',
            textAlignment: TextAlign.left,
            alignment: Alignment.centerLeft,
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 40,
          child: UnitTextCell.columnTitle(
            'TV',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 40,
          child: UnitTextCell.columnTitle(
            'Act',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 60,
          child: UnitTextCell.columnTitle(
            'SP/CP',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 60,
          child: UnitTextCell.columnTitle(
            'Rank',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 65,
          child: UnitTextCell.columnTitle(
            'Duelist',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 40,
          child: UnitTextCell.columnTitle(
            'Vet',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
          width: 75,
          child: UnitTextCell.columnTitle(
            'Upgrades',
          ),
        ),
      ),
      const DataColumn(
        label: SizedBox(
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
    required RuleSet ruleSet,
  }) {
    final settings = context.read<Settings>();

    List<DataRow> dataRows = [];
    var units = group.allUnits();
    for (var i = 0; i < units.length; i++) {
      var unit = units[i];
      final canBeCommand = ruleSet.canBeCommand(unit);
      var movementCell = DataCell(Column(
        children: [
          SizedBox(
            width: _movementIconCellWidth,
            height: 24.0,
            child: IconButton(
              onPressed: unit == units.firstOrNull
                  ? null
                  : () => group.moveUnitUpInList(unit),
              icon: const Icon(
                size: 15.0,
                Icons.arrow_upward,
                color: Colors.blueAccent,
              ),
              splashRadius: 20.0,
            ),
          ),
          SizedBox(
            width: _movementIconCellWidth,
            height: 24.0,
            child: IconButton(
              onPressed: unit == units.lastOrNull
                  ? null
                  : () => group.moveUnitDownInList(unit),
              icon: const Icon(
                size: 15.0,
                Icons.arrow_downward,
                color: Colors.blueAccent,
              ),
              splashRadius: 20.0,
            ),
          ),
        ],
      ));
      var nameCell = DataCell(
        UnitTextCell.content(
          unit.name,
          alignment: Alignment.centerLeft,
          textAlignment: TextAlign.left,
        ),
      );

      final cls = ruleSet.availableCommandLevels(unit);
      var unitCommand = unit.commandLevel;
      if (!cls.any((cl) => cl == unitCommand)) {
        print(
            'Unit: ${unit.name} has command: $unitCommand, but is only allowed to have ${cls.toString()}');

        unitCommand = cls.isEmpty ? CommandLevel.none : cls.first;
      }

      var tvCell = DataCell(UnitTextCell.content(unit.tv.toString()));

      var actionCell = DataCell(UnitTextCell.content(
          unit.actions == null ? '-' : unit.actions.toString()));
      var spCell = DataCell(UnitTextCell.content(
          '${unit.commandLevel == CommandLevel.none ? unit.skillPoints : unit.commandPoints}'));
      var commandCell = DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: DropdownButton<String>(
              value: canBeCommand ? unitCommand.name : null,
              // hint: Text('Select Command Level'),
              icon: const Icon(Icons.arrow_downward),
              iconSize: 16,
              elevation: 16,
              isExpanded: true,
              isDense: true,
              padding: const EdgeInsets.all(0.0),
              style: const TextStyle(color: Colors.blue),
              underline: const SizedBox(),
              onChanged: (String? newValue) {
                setState(() {
                  unit.commandLevel = CommandLevel.fromString(newValue);
                });
              },
              items: canBeCommand
                  ? cls.map<DropdownMenuItem<String>>((CommandLevel value) {
                      return DropdownMenuItem<String>(
                        value: value.name,
                        child: Center(
                          child: Text(
                            value.name,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList()
                  : null,
            ),
          ),
        ],
      ));
      var duelistCell = DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Radio<bool>(
              value: unit.isDuelist,
              groupValue: true,
              toggleable: true,
              onChanged: (bool? value) {},
            ),
          ),
        ],
      ));
      var veteranCell = DataCell(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Radio<bool>(
              value: unit.isVeteran,
              toggleable: true,
              groupValue: true,
              onChanged: (bool? value) {},
            ),
          ),
        ],
      ));
      var upgradeCell = DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: UnitUpgradeButton(
                  unit, group, widget.getOwnCG(), widget.roster),
            ),
          ],
        ),
      );
      var removeCell = DataCell(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: IconButton(
                onPressed: () {
                  {
                    if (settings.requireConfirmationToDeleteUnit) {
                      _showConfirmDelete(context, unit, i, group);
                    } else {
                      group.removeUnit(i);
                    }
                  }
                },
                icon: const Icon(
                  Icons.delete_forever,
                  color: Color.fromARGB(255, 200, 28, 28),
                ),
                splashRadius: 20.0,
                tooltip: 'Remove this unit from the group',
              ),
            ),
          ],
        ),
      );

      var dataRow = DataRow(cells: [
        movementCell,
        nameCell,
        tvCell,
        actionCell,
        spCell,
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

  void _showConfirmDelete(
    BuildContext context,
    Unit unit,
    int unitIndex,
    Group group,
  ) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Column(
        children: [
          const Text(
            'Are you sure you want to remove',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            '${unit.name}?',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      children: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.remove);
          },
          child: const Center(
            child: Text(
              'Yes',
              style: TextStyle(fontSize: 24, color: Colors.red),
            ),
          ),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.pop(context, OptionResult.cancel);
          },
          child: const Center(
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
        case OptionResult.remove:
          setState(() {
            group.removeUnit(unitIndex);
          });
          break;
        default:
      }
    });
  }
}

enum OptionResult { remove, cancel, upgrade }
