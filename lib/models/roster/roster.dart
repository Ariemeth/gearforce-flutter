import 'package:flutter/foundation.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';

class UnitRoster {
  String? player;
  String? name;
  final faction = ValueNotifier<String>("");
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
}
