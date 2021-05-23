import 'package:flutter/foundation.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';

class UnitRoster {
  String? player;
  String? name;
  final faction = ValueNotifier<Factions?>(null);
  final subFaction = ValueNotifier<String>("");
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();

  UnitRoster() {
    faction.addListener(() {
      subFaction.value = "";
    });
  }
  @override
  String toString() {
    return 'Roster: {Player: $player, Force Name: $name, Faction: ${faction.value}, Sub-Faction: ${subFaction.value}}, CGs: $_combatGroups';
  }

  CombatGroup? getCG(String name) => _combatGroups[name];
  void addCG(CombatGroup cg) => _combatGroups[cg.name] = cg;
  int totalTV() {
    var result = 0;
    _combatGroups.forEach((key, value) {
      result += value.totalTV();
    });
    return result;
  }

  List<CombatGroup> getCGs() =>
      _combatGroups.entries.map((e) => e.value).toList();
}
