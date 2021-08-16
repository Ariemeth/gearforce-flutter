import 'package:flutter/foundation.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';

const _currentRosterVersion = 1;
const _currentRulesVersion = '17-July-2021';
const _currentCompendiumVersion = '28-June-2021';

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  final faction = ValueNotifier<FactionType?>(null);
  final subFaction = ValueNotifier<String?>(null);
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();
  int _totalCreated = 0;
  String _activeCG = '';
  String get rulesVersion => _currentRulesVersion;
  String get compendiumVersion => _currentCompendiumVersion;

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

  Map<String, dynamic> toJson() => {
        'player': player,
        'name': name,
        'faction':
            faction.value == null ? null : factionTypeToString(faction.value!),
        'subfaction': subFaction.value,
        'totalCreated': _totalCreated,
        'cgs': _combatGroups.entries.map((e) => e.value.toJson()).toList(),
        'version': _currentRosterVersion,
        'rulesVersion': rulesVersion,
        'compendiumVersion': compendiumVersion,
        'whenCreated': DateTime.now().toString(),
      };

  factory UnitRoster.fromJson(dynamic json, Data data) {
    UnitRoster ur = UnitRoster();
    ur.name = json['name'] as String?;
    ur.player = json['player'] as String?;
    ur.faction.value = (json['faction'] as String?) == null
        ? null
        : convertToFactionType(json['faction'] as String);
    ur.subFaction.value = json['subfaction'] as String?;

    ur._combatGroups.clear();
    var decodedCG = json['cgs'] as List;
    decodedCG
        .map((e) => CombatGroup.fromJson(
              e,
              data,
              ur.faction.value,
              ur.subFaction.value,
            ))
        .toList()
          ..forEach((element) {
            ur.addCG(element);
          });
    ur._totalCreated = json['totalCreated'] as int;
    return ur;
  }

  void copyFrom(UnitRoster ur) {
    this.name = ur.name;
    this.player = ur.player;
    this.faction.value = ur.faction.value;
    this.subFaction.value = ur.subFaction.value;
    this._activeCG = ur._activeCG;
    ur._combatGroups.forEach((key, value) {
      this.addCG(value);
    });
    this._totalCreated = ur._totalCreated;
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
