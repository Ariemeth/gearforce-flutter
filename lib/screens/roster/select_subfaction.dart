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
  final ValueListenable<FactionType?> selectedFaction;
  final ValueNotifier<String?> selectedSubFaction;

  @override
  _SelectSubFactionState createState() => _SelectSubFactionState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectSubFactionState extends State<SelectSubFaction> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<FactionType?>(
      valueListenable: widget.selectedFaction,
      builder: (context, value, child) {
        return DropdownButton<String>(
          value: widget.selectedSubFaction.value,
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
              widget.selectedSubFaction.value = newValue;
            });
          },
          items: _subFactions(),
        );
      },
    );
  }

  List<DropdownMenuItem<String>>? _subFactions() {
    if (widget.selectedFaction.value == null) {
      return null;
    }

    var subfactions = widget.factions
        .firstWhere((f) => f.factionType == widget.selectedFaction.value)
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
