import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/roster/roster.dart';
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
      children: [
        Column(
          children: [
            ...airstrikes
                .map(
                  (airStrike) => AirStrikeRow(
                    airStrike,
                    roster,
                    numberOf: 1,
                  ),
                )
                .toList(),
          ],
        )
      ],
    );
    return optionsDialog;
  }
}

class AirStrikeRow extends StatelessWidget {
  const AirStrikeRow(
    this.unit,
    this.roster, {
    Key? key,
    required this.numberOf,
  }) : super(key: key);

  final UnitCore unit;
  final int numberOf;
  final UnitRoster roster;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('${unit.name}: '),
        IconButton(onPressed: () {}, icon: Icon(Icons.exposure_minus_1)),
        Text(' $numberOf '),
        IconButton(onPressed: () {}, icon: Icon(Icons.exposure_plus_1)),
      ],
    );
  }
}
