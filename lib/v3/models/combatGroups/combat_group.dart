import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gearforce/v3/data/data.dart';
import 'package:gearforce/v3/models/combatGroups/group.dart';
import 'package:gearforce/v3/models/factions/faction.dart';
import 'package:gearforce/v3/models/factions/faction_type.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/options/combat_group_options.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/validation/validations.dart';

class CombatGroup extends ChangeNotifier {
  Group _primary = Group(GroupType.primary);
  Group _secondary = Group(GroupType.secondary);
  String _name;
  bool _isVeteran = false;
  UnitRoster? roster;
  List<CombatGroupOption> _options = [];

  CombatGroup(String name, {Group? primary, Group? secondary, this.roster})
      : _name = name {
    this.primary = primary ?? Group(GroupType.primary);
    this.secondary = secondary ?? Group(GroupType.secondary);
    _resetOptions();
  }

  String get name => _name;
  set name(String newValue) {
    if (_name == newValue) {
      return;
    }

    if (roster != null) {
      if (roster!.getCGs().any((value) => value.name == newValue)) {
        int count = 1;
        String newName = newValue;
        while (roster!.getCGs().any((value) => value.name == newName)) {
          print('Duplicate name found, changing rename to $newName');
          newName = '$newValue ($count)';
          count++;
        }
        newValue = newName;
      }
    }

    _name = newValue;
    notifyListeners();
  }

  int get totalActions => _primary.totalActions + _secondary.totalActions;

  /// Retrieve the options associated with this [CombatGroup].
  List<CombatGroupOption> get options => _options.toList();
  bool hasOption(String id) => _options.any((o) => o.id == id);
  bool isOptionEnabled(String id) {
    return _options.any((o) => o.id == id) &&
        _options.firstWhere((o) => o.id == id).isEnabled;
  }

  /// Retrieve a list of all units in this [CombatGroup].
  List<Unit> get units => _primary.allUnits()..addAll(_secondary.allUnits());

  Group get primary => _primary;
  set primary(Group group) {
    if (_primary.hasListeners) {
      _primary.removeListener(() {
        notifyListeners();
      });
    }
    _primary.combatGroup = null;

    group.combatGroup = this;
    group.addListener(() {
      notifyListeners();
    });
    _primary = group;
  }

  Group get secondary => _secondary;
  set secondary(Group group) {
    if (_secondary.hasListeners) {
      _secondary.removeListener(() {
        notifyListeners();
      });
    }
    _secondary.combatGroup = null;

    group.combatGroup = this;
    group.addListener(() {
      notifyListeners();
    });
    _secondary = group;
  }

  bool get isVeteran => _isVeteran || isEliteForce;
  set isVeteran(bool value) {
    if (value == _isVeteran) {
      return;
    }
    if (value) {
      final vetGroupCount =
          roster?.getCGs().where((cg) => cg._isVeteran).length;
      if (vetGroupCount != null &&
          roster != null &&
          vetGroupCount >=
              roster!.rulesetNotifer.value.maxVetGroups(roster!, this)) {
        return;
      }
    }
    _isVeteran = value;

    notifyListeners();
  }

  List<Unit> get veterans => _primary.veterans + _secondary.veterans;

  bool get isEliteForce => roster != null && roster!.isEliteForce;
  set isEliteForce(bool newValue) {
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'primary': _primary.toJson(),
        'secondary': _secondary.toJson(),
        'name': name,
        'isVet': _isVeteran,
        'enabledOptions':
            _options.where((o) => o.isEnabled).map((o) => o.id).toList(),
      };

  factory CombatGroup.fromJson(
    dynamic json,
    DataV3 data,
    Faction faction,
    RuleSet ruleset,
    UnitRoster roster,
  ) {
    final cg = CombatGroup(
      json['name'] as String,
      roster: roster,
    ).._isVeteran = json['isVet'] != null ? json['isVet'] as bool : false;

    cg._options = roster.rulesetNotifer.value.combatGroupSettings();

    final enabledOptions = json['enabledOptions'] as List;
    for (var optionId in enabledOptions) {
      cg._options
          .where((oo) => oo.id == optionId)
          .forEach((o) => o.isEnabled = true);
    }

    final p = Group.fromJson(
        json['primary'], faction, ruleset, cg, roster, GroupType.primary);
    final s = Group.fromJson(
        json['secondary'], faction, ruleset, cg, roster, GroupType.secondary);
    cg.primary = p;
    cg.secondary = s;

    return cg;
  }

  int totalTV() {
    var total = _primary.totalTV() + _secondary.totalTV();

    // account for drones attached to a recon Hun costing 0
    final dronesInCG = units
        .where((u) =>
            u.type == ModelType.drone &&
            u.faction == FactionType.universalTerraNova)
        .length;
    if (dronesInCG > 0) {
      final hunsInCG =
          units.where((u) => u.core.name.startsWith('Recon Hu')).length;

      final maxFreeDrones = hunsInCG * 3;
      final freeDrones = min(maxFreeDrones, dronesInCG);
      total -= (freeDrones * 2);
    }

    final rs = roster?.rulesetNotifer.value;
    var tvModifier = 0;
    if (rs != null) {
      tvModifier = rs.combatGroupTVModifier(this);
    }

    return total + tvModifier;
  }

  bool hasDuelist() {
    return _primary.hasDuelist() || _secondary.hasDuelist();
  }

  int get duelistCount {
    return _primary.duelistCount + _secondary.duelistCount;
  }

  List<Unit> get duelists => [...primary.duelists, ..._secondary.duelists];

  int modCount(String id) {
    return _primary.modCount(id) + _secondary.modCount(id);
  }

  Unit? getUnitWithCommand(CommandLevel cl) {
    return _primary.getUnitWithCommand(cl) ?? _secondary.getUnitWithCommand(cl);
  }

  List<Unit> getLeaders(CommandLevel? cl) {
    return [..._primary.getLeaders(cl), ..._secondary.getLeaders(cl)];
  }

  List<Unit> unitsWithMod(String id) {
    return _primary.unitsWithMod(id).toList()
      ..addAll(_secondary.unitsWithMod(id).toList());
  }

  List<Unit> unitsWithTrait(Trait trait) {
    return _primary.unitsWithTrait(trait) + _secondary.unitsWithTrait(trait);
  }

  int numUnitsWithMod(String id) {
    return _primary.unitsWithMod(id).length +
        _secondary.unitsWithMod(id).length;
  }

  // Retrieve the total number of units in the combat group
  int numberOfUnits() {
    return _primary.numberOfUnits() + _secondary.numberOfUnits();
  }

  List<Group> get groups => [primary, secondary];

  /// Indicates if there are any units in the [CombatGroup]
  bool isEmpty() => _primary.isEmpty() && _secondary.isEmpty();

  Validations validate({bool tryFix = false}) {
    final Validations validationErrors = Validations();

    final options = roster?.rulesetNotifer.value.combatGroupSettings();
    if (options != null) {
      // if the new options and current _options are the same size and both contain all the same ids, it is good to go
      if (!(options.every((o) => _options.any((oe) => oe.id == o.id)) &&
          options.length == _options.length)) {
        // Options are not the same

        // remove any options from _options that are not in the updated options
        _options.removeWhere((o) => !options.any((uo) => uo.id == o.id));

        //add any new options
        _options.addAll(
            options.where((ou) => !_options.any((oe) => oe.id == ou.id)));
      }
    } else {
      _options.clear();
    }

    final pve = primary.validate(tryFix: tryFix);
    validationErrors.addAll(pve.validations);

    final sve = secondary.validate(tryFix: tryFix);
    validationErrors.addAll(sve.validations);

    // make sure there is at least a CGL in the CG
    final highestRank = highestCommandLevel();
    if (highestRank < CommandLevel.cgl) {
      _tryEnsureCommander(tryFix: tryFix);
      validationErrors.add(const Validation(
        false,
        issue: 'No leader of at least CGL in CG',
      ));
    }

    return validationErrors;
  }

  void _tryEnsureCommander({bool tryFix = false}) {
    if (!tryFix) {
      return;
    }

    final rs = roster?.rulesetNotifer.value;
    if (rs == null) {
      return;
    }

    final allNonLeaders = getLeaders(CommandLevel.none)
        .where((unit) => rs.canBeCommand(unit))
        .toList();
    if (allNonLeaders.isEmpty) {
      return;
    }

    try {
      allNonLeaders
          .firstWhere((u) =>
              rs.availableCommandLevels(u).any((cl) => cl >= CommandLevel.cgl))
          .commandLevel = CommandLevel.cgl;
    } catch (e) {
      print('No units that can be a cgl or better');
    }
  }

  CommandLevel highestCommandLevel() {
    final leaders = getLeaders(null);
    if (leaders.isEmpty) {
      return CommandLevel.none;
    }

    var highRank = CommandLevel.none;

    for (var unit in leaders) {
      highRank = CommandLevel.greaterOne(highRank, unit.commandLevel);
    }

    return highRank;
  }

  void _resetOptions() {
    _options.clear();
    final settings = roster?.rulesetNotifer.value.combatGroupSettings();
    if (settings != null) {
      _options = settings;
    }
  }

  void clear() {
    _primary.reset();
    _secondary.reset();
    _isVeteran = false;
    _resetOptions();
  }

  @override
  String toString() {
    final result =
        'CombatGroup: $name\n\tPrimary: $_primary\n\tSecondary: $_secondary';

    return result;
  }
}
