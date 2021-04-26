import 'package:flutter/foundation.dart';

class UnitRoster {
  String? player;
  String? name;
  final faction = ValueNotifier<String>("");
  final subFaction = ValueNotifier<String>("");

  UnitRoster() {
    faction.addListener(() {
      subFaction.value = "";
    });
  }
  @override
  String toString() {
    return 'Roster: {Player: $player, Force Name: $name, Faction: ${faction.value}, Sub-Faction: ${subFaction.value}}';
  }
}
