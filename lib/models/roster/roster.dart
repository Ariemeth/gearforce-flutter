import 'package:flutter/foundation.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  final faction = ValueNotifier<Factions?>(null);
  final subFaction = ValueNotifier<String?>(null);
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();
  int _totalCreated = 0;
  String _activeCG = '';

  UnitRoster() {
    faction.addListener(() {
      subFaction.value = null;
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

  Map<String, dynamic> toJson() {
    return {
      'player': player,
      'name': name,
      'faction': faction.value.toString().split('.').last,
      'subfaction': subFaction.value,
      'cgs': _combatGroups.entries
          .map((e) => {'name': e.key, 'groups': e.value.toJson()})
          .toList(),
    };
  }

  factory UnitRoster.fromJson(dynamic json) {
    UnitRoster ur = UnitRoster();
    ur.name = json['name'] as String?;
    ur.player = json['player'] as String?;
    ur.faction.value = (json['faction'] as String?) == null
        ? null
        : convertToFaction(json['faction'] as String);
    ur.subFaction.value = json['subfaction'] as String?;

    return ur;
  }

  void copyFrom(UnitRoster ur) {
    this.name = ur.name;
    this.player = ur.player;
    this.faction.value = ur.faction.value;
    this.subFaction.value = ur.subFaction.value;
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
  void setActiveCG(String name) {
    if (_combatGroups.containsKey(name)) {
      _activeCG = name;
    }
  }

  List<CombatGroup> getCGs() =>
      _combatGroups.entries.map((e) => e.value).toList();
}
