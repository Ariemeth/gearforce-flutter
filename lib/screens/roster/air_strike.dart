import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:provider/provider.dart';

class AirStrikeSelectorDialog extends StatelessWidget {
  const AirStrikeSelectorDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();
    final data = context.watch<Data>();

    final airstrikes = data.unitList(FactionType.Airstrike);
    // TODO: maybe create an airstrike counter widget?

    SimpleDialog optionsDialog = SimpleDialog(
      title: Center(child: Text('Airstrikes')),
      children: [
        Column(
          children: [
            // TODO: add airstrikes
            Center(
              child: Text('Air Strikes'),
            ),
          ],
        )
      ],
    );
    return optionsDialog;
  }
}
