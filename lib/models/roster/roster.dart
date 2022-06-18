import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';

const _currentRosterVersion = 1;
const _currentRulesVersion = '3.1';

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  final faction = ValueNotifier<FactionType?>(null);
  final subFaction = ValueNotifier<String?>(null);
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();

  int _totalCreated = 0;
  String _activeCG = '';
  String get rulesVersion => _currentRulesVersion;
  bool _isEliteForce = false;
  final Map<Unit, int> _airStrikes = {};

  UnitRoster() {
    faction.addListener(() {
      subFaction.value = null;
      _combatGroups.forEach((key, value) {
        value.clear();
      });
    });
    createCG();
  }

  bool get isEliteForce => _isEliteForce;
  set isEliteForce(bool newValue) {
    if (newValue == _isEliteForce) {
      return;
    }

    _isEliteForce = newValue;
    notifyListeners();
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
        'isEliteForce': isEliteForce,
        // TODO add saving of airstrikes to json
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
              ur,
            ))
        .toList()
      ..forEach((element) {
        ur.addCG(element);
      });
    ur._totalCreated = json['totalCreated'] as int;
    ur._isEliteForce =
        json['isEliteForce'] != null ? json['isEliteForce'] as bool : false;
    //TODO add loading airstrikes from json
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
    this._isEliteForce = ur._isEliteForce;
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

  void removeCG(String name) {
    _combatGroups.remove(name);
    if (_activeCG == name) {
      _activeCG = '';
    }
    if (_combatGroups.isNotEmpty) {
      _activeCG = _combatGroups.keys.first;
    } else {
      createCG();
    }
    notifyListeners();
  }

  CombatGroup createCG() {
    var cg = CombatGroup('CG ${this._totalCreated + 1}', roster: this);
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

    result += airStrikeTV;
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

  Unit? getFirstUnitWithCommand(CommandLevel cl) {
    for (var cg in _combatGroups.values) {
      final u = cg.getUnitWithCommand(cl);
      if (u != null) {
        return u;
      }
    }
    return null;
  }

  // Retrieve a list of units that have the specified mod attached.
  List<Unit> unitsWithMod(String id) {
    List<Unit> listOfUnits = [];
    _combatGroups
        .forEach((name, cg) => {listOfUnits.addAll(cg.unitsWithMod(id))});
    return listOfUnits;
  }

  Map<Unit, int> get airStrikes => _airStrikes;
  bool addAirStrike(Unit airStrike) {
    if (airStrike.type != 'Airstrike Counter') {
      return false;
    }

    airStrikes.values.forEach((element) {});

    if (_airStrikes.keys.any((element) => element.name == airStrike.name)) {
      _airStrikes[_airStrikes.keys
              .firstWhere((element) => element.name == airStrike.name)] =
          1 +
              _airStrikes[_airStrikes.keys
                  .firstWhere((element) => element.name == airStrike.name)]!;
    } else {
      _airStrikes[airStrike] = 1;
    }
    notifyListeners();
    return true;
  }

  removeAirStrike(String name) {
    if (_airStrikes.keys.any((element) => element.name == name)) {
      final as = _airStrikes.keys.firstWhere((element) => element.name == name);
      final count = _airStrikes[as]!;
      if (count <= 1) {
        _airStrikes.remove(as);
      } else {
        _airStrikes[as] = count - 1;
      }
      notifyListeners();
    }
  }

  int get airStrikeTV {
    int result = 0;

    airStrikes.forEach((airstrike, count) {
      result += (airstrike.tv * count);
    });

    return result;
  }

  void clearAirstrikes() {
    if (airStrikes.isNotEmpty) {
      airStrikes.clear();
      notifyListeners();
    }
  }
}
