import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/models/factions/faction.dart';

/// This is the stateful widget that the main application instantiates.
class SelectFaction extends StatefulWidget {
  final List<Faction> factions;
  final ValueNotifier<String> selectedFaction;
  const SelectFaction(
      {Key? key, required this.factions, required this.selectedFaction})
      : super(key: key);

  @override
  _SelectFactionState createState() =>
      _SelectFactionState(this.factions, this.selectedFaction);
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectFactionState extends State<SelectFaction> {
  String? dropdownValue;

  final List<Faction> factions;
  final ValueNotifier<String> selectedFaction;

  _SelectFactionState(this.factions, this.selectedFaction);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
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
          dropdownValue = newValue!;
          this.selectedFaction.value = newValue;
        });
      },
      items: this.factions.map<DropdownMenuItem<String>>((Faction value) {
        return DropdownMenuItem<String>(
          value: value.name,
          child: Text(
            value.name,
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
