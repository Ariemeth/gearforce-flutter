import 'package:flutter/foundation.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  final faction = ValueNotifier<Factions?>(null);
  final subFaction = ValueNotifier<String>("");
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();
  int _totalCreated = 0;
  String _activeCG = '';

  UnitRoster() {
    faction.addListener(() {
      subFaction.value = "";
      _combatGroups.forEach((key, value) {
        value.clear();
      });
    });
    createCG();
  }
  @override
  String toString() {
    return 'Roster: {Player: $player, Force Name: $name, Faction: ${faction.value}, Sub-Faction: ${subFaction.value}}, CGs: $_combatGroups';
  }

  CombatGroup? getCG(String name) => _combatGroups[name];

  void addCG(CombatGroup cg) {
    cg.addListener(() {
      notifyListeners();
    });
    _combatGroups[cg.name] = cg;
    if (_activeCG == '') {
      _activeCG = cg.name;
    }
    _totalCreated += 1;
    notifyListeners();
  }

  CombatGroup createCG() {
    var cg = CombatGroup('CG ${this._totalCreated + 1}');
    this.addCG(cg);
    if (_activeCG == '') {
      _activeCG = cg.name;
    }
    return cg;
  }

  int totalTV() {
    var result = 0;
    _combatGroups.forEach((key, value) {
      result += value.totalTV();
    });
    return result;
  }

  CombatGroup? activeCG() => _combatGroups[_activeCG];

  List<CombatGroup> getCGs() =>
      _combatGroups.entries.map((e) => e.value).toList();
}
