import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

class SelectForceLeader extends StatefulWidget {
  const SelectForceLeader({
    Key? key,
  }) : super(key: key);

  @override
  _SelectForceLeaderState createState() => _SelectForceLeaderState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectForceLeaderState extends State<SelectForceLeader> {
  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();

    return DropdownButton<Unit?>(
      value: roster.selectedForceLeader,
      hint: Text('Select Force Leader'),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: SizedBox(),
      onChanged: (Unit? newValue) {
        setState(() {
          roster.selectedForceLeader = newValue;
        });
      },
      items: _availableForceLeaders(roster.availableForceLeaders()),
    );
  }

  List<DropdownMenuItem<Unit?>> _availableForceLeaders(List<Unit> units) {
    var menuItems = units.map<DropdownMenuItem<Unit?>>((name) {
      return DropdownMenuItem<Unit?>(
        value: name,
        child: Text(
          name.name,
          style: TextStyle(fontSize: 16),
        ),
      );
    });

    return menuItems.toList();
  }
}
