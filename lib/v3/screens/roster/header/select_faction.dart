import 'package:flutter/material.dart';
import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/factions/faction.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/widgets/settings.dart';
import 'package:provider/provider.dart';

/// This is the stateful widget that the main application instantiates.
class SelectFaction extends StatefulWidget {
  final List<Faction> factions;
  final ValueNotifier<Faction> selectedFaction;
  const SelectFaction(
      {super.key, required this.factions, required this.selectedFaction});

  @override
  State<SelectFaction> createState() => _SelectFactionState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectFactionState extends State<SelectFaction> {
  FactionType? dropdownValue;

  _SelectFactionState();

  @override
  Widget build(BuildContext context) {
    final data = context.watch<DataV3>();
    final settings = context.watch<Settings>();
    final dropdown = DropdownButton<FactionType>(
      value: widget.selectedFaction.value.factionType,
      hint: const Text('Select faction'),
      icon: const Icon(Icons.arrow_downward),
      iconSize: 16,
      elevation: 16,
      isExpanded: true,
      isDense: true,
      style: const TextStyle(color: Colors.blue),
      underline: const SizedBox(),
      onChanged: (FactionType? newValue) {
        setState(() {
          dropdownValue = newValue;
          widget.selectedFaction.value = Faction.fromType(
            newValue!,
            data,
            settings,
          );
        });
      },
      items: _factions(),
    );

    return dropdown;
  }

  List<DropdownMenuItem<FactionType>> _factions() {
    final factions = DataV3.getFactionTypes();

    final List<DropdownMenuItem<FactionType>> menuItems = [];

    for (var value in factions) {
      menuItems.add(DropdownMenuItem<FactionType>(
        value: value,
        child: Text(
          value.name,
          style: const TextStyle(fontSize: 16),
        ),
      ));
    }

    return menuItems;
  }
}
