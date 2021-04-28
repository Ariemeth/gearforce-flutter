import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/models/factions/faction.dart';

class SelectSubFaction extends StatefulWidget {
  const SelectSubFaction(
      {Key? key,
      required this.factions,
      required this.selectedFaction,
      required this.selectedSubFaction})
      : super(key: key);
  final List<Faction> factions;
  final ValueListenable<String> selectedFaction;
  final ValueNotifier<String> selectedSubFaction;

  @override
  _SelectSubFactionState createState() =>
      _SelectSubFactionState(factions, selectedFaction, selectedSubFaction);
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectSubFactionState extends State<SelectSubFaction> {
  String? dropdownValue;
  final List<Faction> factions;
  final ValueListenable<String> selectedFaction;
  final ValueNotifier<String> selectedSubFaction;

  _SelectSubFactionState(
      this.factions, this.selectedFaction, this.selectedSubFaction);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: this.selectedFaction,
      builder: (context, value, child) {
        return DropdownButton<String>(
          value: dropdownValue,
          hint: Text('Select sub-faction'),
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
              this.selectedSubFaction.value = newValue;
            });
          },
          items: _subFactions(),
        );
      },
    );
  }

  List<DropdownMenuItem<String>>? _subFactions() {
    // reset the dropdown value
    this.dropdownValue = null;

    if (this.selectedFaction.value == "") {
      return null;
    }
    var subfactions = this
        .factions
        .firstWhere((f) => f.name == selectedFaction.value)
        .subFactions;

    var menuItems = subfactions.map<DropdownMenuItem<String>>((name) {
      return DropdownMenuItem<String>(
        value: name,
        child: Text(
          name,
          style: TextStyle(fontSize: 16),
        ),
      );
    });

    return menuItems.toList();
  }
}
