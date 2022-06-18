import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';
import 'package:provider/provider.dart';

class AirStrikeSelectorDialog extends StatelessWidget {
  const AirStrikeSelectorDialog(
    this.roster, {
    Key? key,
  }) : super(key: key);

  final UnitRoster roster;

  @override
  Widget build(BuildContext context) {
    final data = context.watch<Data>();

    final airstrikes = data.unitList(
      FactionType.Airstrike,
      includeTerrain: false,
    );

    SimpleDialog optionsDialog = SimpleDialog(
      title: Center(child: Text('Airstrikes')),
      shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            children: airstrikes
                .map((uc) => _buildTableRow(uc, roster,
                    count: roster.airStrikes.keys
                            .any((element) => element.name == uc.name)
                        ? roster.airStrikes[roster.airStrikes.keys
                            .firstWhere((element) => element.name == uc.name)]!
                        : 0))
                .toList(),
          ),
        )
      ],
    );
    return optionsDialog;
  }
}

TableRow _buildTableRow(
  UnitCore unit,
  UnitRoster roster, {
  required int count,
}) {
  return TableRow(children: [
    Text(
      '${unit.name}',
      style: const TextStyle(fontSize: 16),
    ),
    Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: (() => roster.removeAirStrike(unit.name)),
          child: Align(
            child: Text(
              '-',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        Align(
          child: Text(
            '$count',
            style: const TextStyle(fontSize: 28),
          ),
        ),
        TextButton(
          onPressed: (() => roster.addAirStrike(Unit(core: unit))),
          child: Align(
            child: Text(
              '+',
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
      ],
    )
  ]);
}
