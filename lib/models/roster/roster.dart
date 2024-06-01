import 'package:flutter/widgets.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/validation/validations.dart';
import 'package:gearforce/widgets/settings.dart';

const _currentRulesVersion = '3.1 - May 2022';
final _matchExp = RegExp(r'^CG (?<count>\d+)', caseSensitive: false);

class UnitRoster extends ChangeNotifier {
  String? player;
  String? name;
  late final ValueNotifier<Faction> factionNotifier;
  late final ValueNotifier<RuleSet> rulesetNotifer;
  final List<CombatGroup> _combatGroups = new List.empty(growable: true);

  int _totalCreated = 0;
  String _activeCG = '';
  String get rulesVersion => _currentRulesVersion;
  bool _isEliteForce = false;
  Unit? _selectedForceLeader;

  Unit? get selectedForceLeader => _selectedForceLeader;

  int get totalActions => _combatGroups.fold<int>(
      0, (previousValue, cg) => previousValue + cg.totalActions);

  set selectedForceLeader(Unit? newLeader) {
    if (newLeader == _selectedForceLeader) {
      return;
    }
    final onChangedRules = rulesetNotifer.value
        .allEnabledRules(null)
        .where((rule) => rule.onForceLeaderChanged != null);

    _selectedForceLeader = newLeader;

    if (_selectedForceLeader != null) {
      onChangedRules.forEach((rule) {
        rule.onForceLeaderChanged!(this, newLeader);
      });
    }
  }

  UnitRoster(Data data, Settings settings, {bool tryFix = true}) {
    factionNotifier =
        ValueNotifier<Faction>(Faction.blackTalons(data, settings));
    rulesetNotifer =
        ValueNotifier<RuleSet>(factionNotifier.value.defaultSubFaction);

    final rulesetListener = () {
      _combatGroups.forEach((cg) {
        cg.validate(tryFix: tryFix);
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
      _combatGroups.forEach((cg) {
        cg.validate(tryFix: tryFix);
      });

      if (_combatGroups.length > 1) {
        _combatGroups.removeWhere((cg) => cg.units.length == 0);
        if (_combatGroups.length == 0) {
          createCG();
        }
      }

      rulesetNotifer.value.addListener(rulesetListener);
      validate(tryFix: tryFix);

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

    _combatGroups.forEach((cg) {
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
    _combatGroups.forEach((cg) {
      allUnits.addAll(cg.units);
    });
    return allUnits;
  }

  @override
  String toString() {
    final result = '\nRoster:\n' +
        '\tPlayer: $player \tForce Name: $name\n' +
        '\tFaction: ${factionNotifier.value.name} \\ ${rulesetNotifer.value.name}\n' +
        '${_combatGroups.join('\n')}\n\n';

    return result;
  }

  Map<String, dynamic> toJson() => {
        'player': player,
        'name': name,
        'faction': {
          'name': factionNotifier.value.factionType.name,
          'enabledRules': rulesetNotifer.value.factionRules
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
        'cgs': _combatGroups.map((e) => e.toJson()).toList(),
        'version': 3,
        'rulesVersion': rulesVersion,
        'isEliteForce': isEliteForce,
        'whenCreated': DateTime.now().toString(),
      };

  factory UnitRoster.fromJson(dynamic json, Data data, Settings settings) {
    final version = json['version'] as int;
    UnitRoster ur = UnitRoster(data, settings);
    ur.name = json['name'] as String?;
    ur.player = json['player'] as String?;

    String? faction;
    switch (version) {
      case 0:
      case 1:
      case 2:
        faction = _loadV2Faction(
          json['faction'] as String?,
          ur,
          data,
          settings,
        );
        break;
      default:
        faction = _loadV3Faction(
          json['faction'] as Map<String, dynamic>?,
          ur,
          data,
          settings,
        );
        break;
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

    var decodedCG = json['cgs'];
    final cgList = decodedCG
        .map((e) => CombatGroup.fromJson(
              e,
              data,
              ur.factionNotifier.value,
              ur.rulesetNotifer.value,
              ur,
            ))
        .toList();

    cgList.forEach((cg) {
      ur.addCG(cg);
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
    ur._totalCreated = json['totalCreated'] as int;
    ur.validate();

    return ur;
  }

  static String? _loadV2Faction(
      String? faction, UnitRoster ur, Data data, Settings settings) {
    if (faction != null) {
      try {
        final f = Faction.fromType(
          FactionType.fromName(faction),
          data,
          settings,
        );
        ur.factionNotifier.value = f;
      } catch (e) {
        print(e);
      }
    }
    return faction;
  }

  static String? _loadV3Faction(
    Map<String, dynamic>? factionJson,
    UnitRoster ur,
    Data data,
    Settings settings,
  ) {
    if (factionJson == null) {
      return null;
    }

    final factionName = factionJson['name'] as String?;
    if (factionName == null) {
      return null;
    }

    try {
      final f = Faction.fromType(
        FactionType.fromName(factionName),
        data,
        settings,
      );
      ur.factionNotifier.value = f;
    } catch (e) {
      print(e);
    }

    final factionRules = factionJson['enabledRules'] as List;
    factionRules.forEach((factionRule) {
      final ruleId = factionRule['id'];
      final rules = ur.rulesetNotifer.value.factionRules;
      final rule = rules.where((r) => r.id == ruleId).first;
      rule.setIsEnabled(true, rules);

      final options = factionRule['options'] as List?;
      options?.forEach((optionRuleId) {
        final optionRules = rule.options;
        final optionRule =
            optionRules?.where((r) => r.id == optionRuleId).first;
        optionRule?.setIsEnabled(true, optionRules!);
      });
    });

    return factionName;
  }

  void copyFrom(UnitRoster ur) {
    this.name = ur.name;
    this.player = ur.player;
    this.factionNotifier.value = ur.factionNotifier.value;
    this.rulesetNotifer.value = ur.rulesetNotifer.value;
    this._activeCG = ur._activeCG;
    this._combatGroups.clear();
    ur._combatGroups.forEach((cg) {
      this.addCG(cg);
    });
    this._totalCreated = ur._totalCreated;
    this._isEliteForce = ur._isEliteForce;
    this.selectedForceLeader = ur.selectedForceLeader;
  }

  CombatGroup? getCG(String name) {
    if (_combatGroups.any((cg) => cg.name == name)) {
      return _combatGroups.firstWhere((cg) => cg.name == name);
    }
    return null;
  }

  void addCG(CombatGroup cg) {
    cg.roster = this;
    if (_combatGroups.any((value) => value.name == cg.name)) {
      int count = 1;
      String newName = cg.name;
      while (_combatGroups.any((value) => value.name == newName)) {
        print('Duplicate name found: $newName');
        newName = '${cg.name} ($count)';
        count++;
      }
      cg.name = newName;
    }

    cg.addListener(() {
      validate();
      notifyListeners();
    });

    _combatGroups.add(cg);
    if (_activeCG == '') {
      _activeCG = cg.name;
    }
    _totalCreated += 1;
    notifyListeners();
  }

  void removeCG(String name) {
    // if the cg isn't part of the roster no need to do any more checks
    if (!_combatGroups.any((cg) => cg.name == name)) {
      return;
    }

    _combatGroups.where((cg) => cg.name == name).forEach((cg) {
      cg.roster = null;
    });

    _combatGroups.removeWhere((cg) => cg.name == name);
    if (_activeCG == name) {
      _activeCG = '';
    }
    if (_combatGroups.isNotEmpty) {
      _activeCG = _combatGroups.first.name;
    } else {
      createCG();
    }
    notifyListeners();
  }

  CombatGroup createCG() {
    var nextCGNumber = 1;

    if (_combatGroups.isNotEmpty) {
      final defaultNamedCgs = _combatGroups.where((cg) {
        return _matchExp.hasMatch(cg.name);
      }).toList();

      final groupNumbers = defaultNamedCgs
          .map((cg) =>
              int.parse(_matchExp.firstMatch(cg.name)!.namedGroup('count')!))
          .toList();

      final groupNumberMap = Map<int, int>.fromIterable(groupNumbers,
          key: (v) => v, value: (v) => v);

      for (var i = nextCGNumber; i <= groupNumbers.length; i++) {
        if (groupNumberMap.containsKey(i)) {
          nextCGNumber = i + 1;
        } else {
          break;
        }
      }
    }
    var cg = CombatGroup('CG ${nextCGNumber}', roster: this);
    this.addCG(cg);
    if (_activeCG == '') {
      _activeCG = cg.name;
    }
    return cg;
  }

  int totalTV() {
    var result = 0;
    _combatGroups.forEach((cg) {
      result += cg.totalTV();
    });

    return result;
  }

  CombatGroup? activeCG() {
    if (_activeCG == '') {
      return null;
    }
    if (!_combatGroups.any((cg) => cg.name == _activeCG)) {
      return null;
    }
    return _combatGroups.firstWhere((cg) => cg.name == _activeCG);
  }

  void setActiveCG(String name) {
    if (name == _activeCG) {
      return;
    }
    if (_combatGroups.any((cg) => cg.name == name)) {
      _activeCG = name;
      notifyListeners();
    }
  }

  List<CombatGroup> getCGs() => new List<CombatGroup>.from(_combatGroups);

  int get combatGroupCount =>
      _combatGroups.where((cg) => cg.units.isNotEmpty).length;

  Unit? getFirstUnitWithCommand(CommandLevel cl) {
    for (var cg in _combatGroups) {
      final u = cg.getUnitWithCommand(cl);
      if (u != null) {
        return u;
      }
    }
    return null;
  }

  List<Unit> getLeaders(CommandLevel? cl) {
    final List<Unit> leaders = [];
    _combatGroups.forEach((cg) {
      leaders.addAll(cg.getLeaders(cl));
    });
    return leaders;
  }

  // Retrieve a list of combatgroups that have at least 1 unit with a
  // specific mod.
  List<CombatGroup?> combatGroupsWithMod(String id) {
    List<CombatGroup?> results = [];
    _combatGroups.forEach((cg) {
      if (cg.modCount(id) > 0) {
        results.add(cg);
      }
    });
    return results;
  }

  // Retrieve a list of units that have the specified mod attached.
  List<Unit> unitsWithMod(String id) {
    List<Unit> listOfUnits = [];
    _combatGroups.forEach((cg) => listOfUnits.addAll(cg.unitsWithMod(id)));
    return listOfUnits;
  }

  List<Unit> unitsWithTrait(Trait trait) {
    final List<Unit> results = [];

    _combatGroups.forEach((cg) {
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
    _combatGroups.forEach((cg) {
      results.addAll(cg.duelists);
    });
    return results;
  }

  int totalAirstrikeCounters() {
    var total = 0;
    _combatGroups.forEach((cg) {
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

  Validations validate({bool tryFix = true}) {
    final Validations validationErrors = Validations();
    final ruleset = rulesetNotifer.value;

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
    // if there are no available force leaders ensure the selected force leader is null
    if (!forceLeaders.contains(selectedForceLeader)) {
      // there are available force leaders so make sure there is a valid one selected
      selectedForceLeader = forceLeaders.firstOrNull;
    }

    _combatGroups.forEach((cg) {
      final ve = cg.validate(tryFix: tryFix);

      validationErrors.addAll(ve.validations);
    });
    return validationErrors;
  }
}
