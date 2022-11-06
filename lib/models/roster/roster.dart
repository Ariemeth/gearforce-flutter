import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/factions/sub_faction.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';

const _currentRosterVersion = 2;
const _currentRulesVersion = '3.1';

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  late final ValueNotifier<Faction> faction;
  late final ValueNotifier<SubFaction> subFaction;
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();

  int _totalCreated = 0;
  String _activeCG = '';
  String get rulesVersion => _currentRulesVersion;
  bool _isEliteForce = false;

  UnitRoster(Data data) {
    faction = ValueNotifier<Faction>(Faction.blackTalons(data));
    subFaction = ValueNotifier<SubFaction>(faction.value.defaultSubFaction);
    faction.addListener(() {
      subFaction.value = faction.value.defaultSubFaction;
      _combatGroups.forEach((key, value) {
        value.clear();
      });
      subFaction.addListener(() {
        notifyListeners();
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
        'faction': faction.value.factionType.name,
        'subfaction': subFaction.value.name,
        'totalCreated': _totalCreated,
        'cgs': _combatGroups.entries.map((e) => e.value.toJson()).toList(),
        'version': _currentRosterVersion,
        'rulesVersion': rulesVersion,
        'isEliteForce': isEliteForce,
        'whenCreated': DateTime.now().toString(),
      };

  factory UnitRoster.fromJson(dynamic json, Data data) {
    UnitRoster ur = UnitRoster(data);
    ur.name = json['name'] as String?;
    ur.player = json['player'] as String?;
    final faction = json['faction'] as String?;
    if (faction != null) {
      try {
        final f = Faction.fromType(FactionType.fromName(faction), data);
        ur.faction.value = f;
      } on Exception catch (e) {
        print(e);
      }
    }
    final subFactionName = json['subfaction'] as String?;
    if (subFactionName != null && faction != null) {
      if (ur.faction.value.subFactions
          .any((sub) => sub.name == subFactionName)) {
        ur.subFaction.value = ur.faction.value.subFactions
            .firstWhere((sub) => sub.name == subFactionName);
      }
    }

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

  // Retrieve a list of combatgroups that have at least 1 unit with a
  // specific mod.
  List<CombatGroup?> combatGroupsWithMod(String id) {
    List<CombatGroup?> results = [];
    _combatGroups.forEach((_, cg) {
      if (cg.modCount(id) > 0) {
        results.add(cg);
      }
    });
    return results;
  }

  // Retrieve a list of units that have the specified mod attached.
  List<Unit> unitsWithMod(String id) {
    List<Unit> listOfUnits = [];
    _combatGroups
        .forEach((name, cg) => {listOfUnits.addAll(cg.unitsWithMod(id))});
    return listOfUnits;
  }

  int numberUnitsWithTag(String tag) {
    return unitsWithTag(tag).length;
  }

  List<Unit> unitsWithTag(String tag) {
    List<Unit> listOfUnits = [];
    _combatGroups
        .forEach((name, cg) => listOfUnits.addAll(cg.unitsWithTag(tag)));
    return listOfUnits;
  }

  // Returns true if the Roster currently has a duelist.
  bool hasDuelist() {
    for (final cg in getCGs()) {
      if (cg.hasDuelist()) {
        return true;
      }
    }
    return false;
  }
}
