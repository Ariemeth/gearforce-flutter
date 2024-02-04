import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/rules/rule_set.dart';

class SelectSubFaction extends StatefulWidget {
  const SelectSubFaction(
      {Key? key,
      required this.factions,
      required this.selectedFaction,
      required this.selectedSubFaction})
      : super(key: key);
  final List<Faction> factions;
  final ValueListenable<Faction> selectedFaction;
  final ValueNotifier<RuleSet> selectedSubFaction;

  @override
  _SelectSubFactionState createState() => _SelectSubFactionState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _SelectSubFactionState extends State<SelectSubFaction> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Faction>(
      valueListenable: widget.selectedFaction,
      builder: (context, value, child) {
        return DropdownButton<RuleSet>(
          value: widget.selectedSubFaction.value,
          hint: Text('Select sub-list'),
          icon: const Icon(Icons.arrow_downward),
          iconSize: 16,
          elevation: 16,
          isExpanded: true,
          isDense: true,
          style: const TextStyle(color: Colors.blue),
          underline: SizedBox(),
          onChanged: (RuleSet? newValue) {
            setState(() {
              widget.selectedSubFaction.value = newValue!;
            });
          },
          items: _subFactions(),
        );
      },
    );
  }

  List<DropdownMenuItem<RuleSet>> _subFactions() {
    final subfactions = widget.selectedFaction.value.rulesets;

    var menuItems = subfactions.map<DropdownMenuItem<RuleSet>>((name) {
      return DropdownMenuItem<RuleSet>(
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
