import 'package:flutter/material.dart';
import 'package:gearforce/models/roster/roster.dart';

class AirStrikeSelectorDialog extends StatelessWidget {
  const AirStrikeSelectorDialog({
    Key? key,
    required this.roster,
  }) : super(key: key);

  final UnitRoster roster;

  @override
  Widget build(BuildContext context) {
    SimpleDialog optionsDialog = SimpleDialog(
      title: Column(
        children: [
          Center(
            child: Text('Air Strikes'),
          ),
        ],
      ),
    );
    return optionsDialog;
  }
}
