import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/validation/validations.dart';

const _currentRosterVersion = 2;
const _currentRulesVersion = '3.1 - May 2022';

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  late final ValueNotifier<Faction> factionNotifier;
  late final ValueNotifier<RuleSet> rulesetNotifer;
  final Map<String, CombatGroup> _combatGroups = new Map<String, CombatGroup>();

  int _totalCreated = 0;
  String _activeCG = '';
  String get rulesVersion => _currentRulesVersion;
  bool _isEliteForce = false;
  Unit? selectedForceLeader;

  UnitRoster(Data data) {
    factionNotifier = ValueNotifier<Faction>(Faction.blackTalons(data));
    rulesetNotifer =
        ValueNotifier<RuleSet>(factionNotifier.value.defaultSubFaction);

    final rulesetListener = () {
      _combatGroups.forEach((key, value) {
        value.validate(tryFix: true);
      });
      notifyListeners();
    };

    rulesetNotifer.value.addListener(rulesetListener);

    factionNotifier.addListener(() {
      rulesetNotifer.value = factionNotifier.value.defaultSubFaction;
      _totalCreated = 0;
      _combatGroups.clear();
      createCG();
    });

    rulesetNotifer.addListener(() {
      // Ensure each combat group is clear
      _combatGroups.forEach((key, value) {
        value.validate(tryFix: true);
      });

      if (_combatGroups.length > 1) {
        _combatGroups.removeWhere((key, value) => value.units.length == 0);
        if (_combatGroups.length == 0) {
          createCG();
        }
      }

      rulesetNotifer.value.addListener(rulesetListener);
      validate(rulesetNotifer.value);
      notifyListeners();
    });

    createCG();
  }

  bool get isEliteForce => _isEliteForce;
  set isEliteForce(bool newValue) {
    if (newValue == _isEliteForce) {
      return;
    }

    _isEliteForce = newValue;

    _combatGroups.forEach((id, cg) {
      cg.isEliteForce = newValue;
    });

    notifyListeners();
  }

  List<Unit> availableForceLeaders() {
    final tfcs = getLeaders(CommandLevel.tfc);
    if (tfcs.isNotEmpty) {
      return tfcs;
    }

    final cos = getLeaders(CommandLevel.co);
    if (cos.isNotEmpty) {
      return cos;
    }

    final xos = getLeaders(CommandLevel.xo);
    if (xos.isNotEmpty) {
      return xos;
    }

    final cgls = getLeaders(CommandLevel.cgl);
    if (cgls.isNotEmpty) {
      return cgls;
    }

    final secics = getLeaders(CommandLevel.secic);
    if (secics.isNotEmpty) {
      return secics;
    }

    // any remaining leaders would be third in commands
    return getLeaders(null);
  }

  List<Unit> getAllUnits() {
    final List<Unit> allUnits = [];
    _combatGroups.entries.forEach((me) {
      allUnits.addAll(me.value.units);
    });
    return allUnits;
  }

  @override
  String toString() {
    final result = '\nRoster:\n' +
        '\tPlayer: $player \tForce Name: $name\n' +
        '\tFaction: ${factionNotifier.value.name} \\ ${rulesetNotifer.value.name}\n' +
        '${_combatGroups.values.join('\n')}\n\n';

    return result;
  }

  Map<String, dynamic> toJson() => {
        'player': player,
        'name': name,
        'faction': factionNotifier.value.factionType.name,
        'subfaction': {
          'name': rulesetNotifer.value.name,
          'enabledRules': rulesetNotifer.value.subFactionRules
              .where((r) => r.isEnabled)
              .map((r) => {
                    'id': r.id,
                    'options': r.options
                        ?.where((o) => o.isEnabled)
                        .map((o) => o.id)
                        .toList(),
                  })
              .toList(),
        },
        'forceLeader': {
          'cg': selectedForceLeader?.group?.combatGroup?.name,
          'group': selectedForceLeader?.group?.groupType.name,
          'unit': selectedForceLeader?.name,
          'position': selectedForceLeader?.group
              ?.allUnits()
              .indexOf(selectedForceLeader!),
        },
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
        ur.factionNotifier.value = f;
      } on Exception catch (e) {
        print(e);
      }
    }
    final subFaction = json['subfaction'];
    final subFactionName = subFaction['name'] as String?;
    if (subFactionName != null && faction != null) {
      if (ur.factionNotifier.value.rulesets
          .any((sub) => sub.name == subFactionName)) {
        ur.rulesetNotifer.value = ur.factionNotifier.value.rulesets
            .firstWhere((sub) => sub.name == subFactionName);
      }
      final subRules = subFaction['enabledRules'] as List;
      subRules.forEach((subRule) {
        final ruleId = subRule['id'];
        final rules = ur.rulesetNotifer.value.subFactionRules;
        final rule = rules.where((r) => r.id == ruleId).first;
        rule.setIsEnabled(true, rules);

        final options = subRule['options'] as List?;
        options?.forEach((optionRuleId) {
          final optionRules = rule.options;
          final optionRule =
              optionRules?.where((r) => r.id == optionRuleId).first;
          optionRule?.setIsEnabled(true, optionRules!);
        });
      });
    }

    ur._combatGroups.clear();
    ur._isEliteForce =
        json['isEliteForce'] != null ? json['isEliteForce'] as bool : false;
    ur._totalCreated = json['totalCreated'] as int;
    var decodedCG = json['cgs'];
    decodedCG
        .map((e) => CombatGroup.fromJson(
              e,
              data,
              ur.factionNotifier.value,
              ur.rulesetNotifer.value,
              ur,
            ))
        .toList()
      ..forEach((element) {
        ur.addCG(element);
      });

    try {
      final leaderJson = json['forceLeader'];
      if (leaderJson != null && leaderJson['unit'] != null) {
        final leader = ur.availableForceLeaders().firstWhere((unit) {
          final unitName = leaderJson['unit'] as String;
          final groupName = leaderJson['group'] as String;
          final cgName = leaderJson['cg'] as String;
          final unitPosition = leaderJson['position'] as int;
          return (unit.name == unitName) &&
              (unit.group?.groupType.name == groupName) &&
              (unit.group?.combatGroup?.name == cgName) &&
              (unit.group?.allUnits().indexOf(unit) == unitPosition);
        });

        ur.selectedForceLeader = leader;
      }
    } catch (e) {
      print('Error loading force leader: $e');
    }
    ur.validate(ur.rulesetNotifer.value);

    return ur;
  }

  void copyFrom(UnitRoster ur) {
    this.name = ur.name;
    this.player = ur.player;
    this.factionNotifier.value = ur.factionNotifier.value;
    this.rulesetNotifer.value = ur.rulesetNotifer.value;
    this._activeCG = ur._activeCG;
    ur._combatGroups.forEach((key, cg) {
      this.addCG(cg);
    });
    this._totalCreated = ur._totalCreated;
    this._isEliteForce = ur._isEliteForce;
    this.selectedForceLeader = ur.selectedForceLeader;
  }

  CombatGroup? getCG(String name) => _combatGroups[name];

  void addCG(CombatGroup cg) {
    cg.addListener(() {
      validate(rulesetNotifer.value);
      notifyListeners();
    });
    cg.roster = this;
    _combatGroups[cg.name] = cg;
    if (_activeCG == '') {
      _activeCG = cg.name;
    }
    _totalCreated += 1;
    notifyListeners();
  }

  void removeCG(String name) {
    // if the cg isn't part of the roster no need to do any more checks
    if (!_combatGroups.keys.any((key) => key == name)) {
      return;
    }

    _combatGroups[name]?.roster = null;

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
    if (name == _activeCG) {
      return;
    }
    if (_combatGroups.containsKey(name)) {
      _activeCG = name;
      notifyListeners();
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

  List<Unit> getLeaders(CommandLevel? cl) {
    final List<Unit> leaders = [];
    _combatGroups.forEach((_, cg) {
      leaders.addAll(cg.getLeaders(cl));
    });
    return leaders;
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
        .forEach((name, cg) => listOfUnits.addAll(cg.unitsWithMod(id)));
    return listOfUnits;
  }

  List<Unit> unitsWithTrait(Trait trait) {
    final List<Unit> results = [];

    _combatGroups.entries.map((e) => e.value).forEach((cg) {
      results.addAll(cg.unitsWithTrait(trait));
    });

    return results;
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

  int get duelistCount {
    int result = 0;
    getCGs().forEach((cg) {
      result = result + cg.duelistCount;
    });
    return result;
  }

  List<Unit> get duelists {
    final List<Unit> results = [];
    _combatGroups.forEach((_, cg) {
      results.addAll(cg.duelists);
    });
    return results;
  }

  int totalAirstrikeCounters() {
    var total = 0;
    _combatGroups.forEach((key, cg) {
      total +=
          cg.units.where((u) => u.type == ModelType.AirstrikeCounter).length;
    });
    return total;
  }

  List<FactionType> allModelFactions() {
    final List<FactionType> results = [];
    getAllUnits().forEach((unit) {
      final f = unit.faction;
      if (!results.any((r) => r == f)) {
        results.add(f);
      }
    });
    return results;
  }

  Validations validate(RuleSet ruleset) {
    final Validations validationErrors = Validations();

    final allRules = ruleset.allFactionRules(factions: allModelFactions());
    allRules.forEach((rule) {
      if (rule.isEnabled && !rule.requirementCheck(allRules)) {
        validationErrors.add(Validation(
          false,
          issue: 'Rule ${rule.name} fails requirement check',
        ));
        print('Disabling rule ${rule.name}');
        rule.setIsEnabled(false, allRules);
      }
    });

    final forceLeaders = availableForceLeaders();
    if (!forceLeaders.any((unit) => unit == selectedForceLeader)) {
      selectedForceLeader =
          forceLeaders.length == 1 ? forceLeaders.first : null;
    }

    _combatGroups.forEach((key, cg) {
      final ve = cg.validate(tryFix: true);

      validationErrors.addAll(ve.validations);
    });
    return validationErrors;
  }
}
