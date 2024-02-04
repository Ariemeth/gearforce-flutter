import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:provider/provider.dart';

/// This is the stateful widget that the main application instantiates.
class SelectFaction extends StatefulWidget {
  final List<Faction> factions;
  final ValueNotifier<Faction> selectedFaction;
  const SelectFaction(
      {Key? key, required this.factions, required this.selectedFaction})
      : super(key: key);

  @override
  _SelectFactionState createState() => _SelectFactionState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectFactionState extends State<SelectFaction> {
  FactionType? dropdownValue;

  _SelectFactionState();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<Data>();
    return DropdownButton<FactionType?>(
      value: widget.selectedFaction.value.factionType,
      hint: Text('Select faction'),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: SizedBox(),
      onChanged: (FactionType? newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.selectedFaction.value = Faction.fromType(newValue!, data);
        });
      },
      items:
          widget.factions.map<DropdownMenuItem<FactionType>>((Faction value) {
        return DropdownMenuItem<FactionType>(
          value: value.factionType,
          child: Text(
            value.factionType.name,
            style: TextStyle(fontSize: 16),
          ),
        );
      }).toList(),
    );
  }
}
