import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/unit/unit.dart';

class SelectForceLeader extends StatefulWidget {
  const SelectForceLeader({
    super.key,
  });

  @override
  _SelectForceLeaderState createState() => _SelectForceLeaderState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectForceLeaderState extends State<SelectForceLeader> {
  @override
  Widget build(BuildContext context) {
    final roster = context.watch<UnitRoster>();
    final availableUnits = roster.availableForceLeaders();
    var selectedLeader = roster.selectedForceLeader;

    if (selectedLeader != null && !availableUnits.contains(selectedLeader)) {
      print(
          'Selected leader is not in the available units list, leader: $selectedLeader, available: $availableUnits');
      selectedLeader = null;
    }

    return DropdownButton<Unit?>(
      value: selectedLeader,
      hint: const Text('Select Force Leader'),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: const SizedBox(),
      onChanged: (Unit? newValue) {
        setState(() {
          roster.selectedForceLeader = newValue;
        });
      },
      items: _availableForceLeaders(availableUnits),
    );
  }

  List<DropdownMenuItem<Unit?>> _availableForceLeaders(List<Unit> units) {
    var menuItems = units.map<DropdownMenuItem<Unit?>>((name) {
      return DropdownMenuItem<Unit?>(
        value: name,
        child: Text(
          name.name,
          style: const TextStyle(fontSize: 16),
        ),
      );
    });

    return menuItems.toList();
  }
}
