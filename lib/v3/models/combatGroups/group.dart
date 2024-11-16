import 'package:flutter/material.dart';
import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/factions/faction.dart';
import 'package:gearforce/v3/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/command.dart';
import 'package:gearforce/v3/models/unit/model_type.dart';
import 'package:gearforce/v3/models/unit/role.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/validation/validations.dart';

const RoleType _defaultRoleType = RoleType.gp;

enum GroupType {
  primary('Primary'),
  secondary('Secondary');

  const GroupType(this.name);
  final String name;
}

class Group extends ChangeNotifier {
  RoleType _role = _defaultRoleType;
  final List<Unit> _units = [];
  final GroupType groupType;
  CombatGroup? combatGroup;

  Group(this.groupType, {RoleType role = _defaultRoleType}) {
    _role = role;
  }

  Map<String, dynamic> toJson() => {
        'role': _role.toString().split('.').last.toUpperCase(),
        'units': _units.map((e) => e.toJson()).toList(),
      };

  factory Group.fromJson(
    dynamic json,
    Faction faction,
    RuleSet ruleset,
    CombatGroup cg,
    UnitRoster roster,
    GroupType groupType,
  ) {
    Group g = Group(groupType, role: convertRoleType(json['role'] as String));
    g.combatGroup = cg;

    var jsonUnits = json['units'];
    if (jsonUnits == null) {
      return g;
    }

    var decodedUnits = jsonUnits as List<dynamic>;
    decodedUnits
        .map((du) {
          try {
            return Unit.fromJson(du, faction, ruleset, cg, roster);
          } catch (e) {
            print(
                'Exception caught while decoding unit $du in ${cg.name} $groupType group: $e');
            return null;
          }
        })
        .toList()
        .forEach((u) {
          if (u != null) {
            g._addUnit(u);
          }
        });

    return g;
  }

  RoleType role() => _role;

  void changeRole(RoleType role) {
    if (role == _role) {
      return;
    }

    _role = role;

    notifyListeners();
  }

  Validations _addUnit(Unit unit) {
    final validations = Validations();
    if (_units.contains(unit)) {
      validations.add(Validation(
        false,
        issue: 'Unit ${unit.name} is already in $groupType in $combatGroup',
      ));
      return validations;
    }

    // Check if the unit is part of an elite force of all vets and if so make
    // sure all units are vets.
    final inEliteForce = combatGroup?.roster?.isEliteForce;
    if (inEliteForce != null && inEliteForce && !unit.isVeteran) {
      final e = _ensureVetStatus(unit, tryFix: true);
      if (e.isNotValid()) {
        validations.addAll(e.validations);
        return validations;
      }
    }

    unit.group = this;
    unit.addListener(() {
      notifyListeners();
    });

    _units.add(unit);
    final rs = combatGroup?.roster?.rulesetNotifer.value;
    if (rs != null) {
      final onAddedRules = rs
          .allFactionRules(unit: unit)
          .where((rule) => rule.onUnitAdded != null);
      for (var rule in onAddedRules) {
        rule.onUnitAdded!(combatGroup!.roster!, unit);
      }
    }
    return validations;
  }

  void addUnit(Unit unit) {
    final validations = _addUnit(unit);
    if (validations.isNotValid()) {
      print(validations.toString());
    } else {
      unit.group ??= this;
      notifyListeners();
    }
  }

  void removeUnit(int index) {
    if (index < _units.length) {
      _units.elementAt(index).removeListener(() {
        notifyListeners();
      });
      _units.elementAt(index).group = null;
      _units.removeAt(index);
    }
    notifyListeners();
  }

  bool moveUnitUpInList(Unit unit) {
    final index = _units.indexOf(unit);
    if (index <= 0) {
      return false;
    }

    _units.removeAt(index);
    _units.insert(index - 1, unit);
    notifyListeners();
    return true;
  }

  bool moveUnitDownInList(Unit unit) {
    final index = _units.indexOf(unit);
    if (index < 0 || index >= _units.length - 1) {
      return false;
    }

    _units.removeAt(index);
    _units.insert(index + 1, unit);
    notifyListeners();
    return true;
  }

  List<Unit> allUnits() {
    return _units.toList();
  }

  // Retrieve the number of units in the group.
  int numberOfUnits() {
    return _units.length;
  }

  Unit? getUnitWithCommand(CommandLevel cl) {
    return _units.any((u) => u.commandLevel == cl)
        ? _units.firstWhere((u) => u.commandLevel == cl)
        : null;
  }

  List<Unit> getLeaders(CommandLevel? cl) {
    if (cl != null) {
      return _units.where((unit) => unit.commandLevel == cl).toList();
    }

    return _units
        .where((unit) => unit.commandLevel != CommandLevel.none)
        .toList();
  }

  int modCount(String id) {
    return unitsWithMod(id).length;
  }

  List<Unit> unitsWithMod(String id) {
    return _units.where((unit) => unit.hasMod(id)).toList();
  }

  List<Unit> unitsWithTrait(Trait trait) {
    return _units.where((unit) => unit.traits.any((t) => t == trait)).toList();
  }

  bool isEmpty() => _units.isEmpty;

  void reset() {
    _role = _defaultRoleType;
    _units.clear();
    notifyListeners();
  }

  int totalTV() {
    var total = 0;
    for (var u in _units) {
      total += u.tv;
    }

    return total;
  }

  int get totalActions {
    var total = 0;
    for (var u in _units) {
      total += u.actions ?? 0;
    }
    return total;
  }

  bool hasDuelist() {
    return _units.any((u) => u.isDuelist);
  }

  int get duelistCount {
    if (!hasDuelist()) {
      return 0;
    }
    return _units.where((u) => u.isDuelist).length;
  }

  List<Unit> get duelists => _units.where((unit) => unit.isDuelist).toList();

  List<Unit> get veterans => _units.where((unit) => unit.isVeteran).toList();

  Validations _ensureVetStatus(Unit u, {bool tryFix = false}) {
    final results = Validations();

    if (u.type == ModelType.drone ||
        u.type == ModelType.terrain ||
        u.type == ModelType.areaTerrain ||
        u.isVeteran) {
      return results;
    }

    final rs = combatGroup?.roster?.rulesetNotifer.value;

    final makeVet = VeteranModification.makeVet(u, combatGroup!);
    if (rs != null &&
        makeVet.requirementCheck(
          rs,
          combatGroup?.roster,
          combatGroup,
          u,
        )) {
      u.addUnitMod(makeVet);
      return results;
    }

    if (tryFix) {
      _units.remove(u);
    }

    results.add(Validation(false, issue: 'Unit ${u.name} can not be a vet'));

    return results;
  }

  Validations validate({bool tryFix = false}) {
    final Validations validationErrors = Validations();

    _units.toList().forEach((u) {
      final ve = u.validate(tryFix: tryFix);
      validationErrors.addAll(ve.validations);
    });

    if (combatGroup != null && combatGroup!.roster != null) {
      final tempList = _units.toList(growable: false);
      for (var u in tempList) {
        // Check if the unit is part of a veteran/elite force and if so make sure all
        // units are vets.
        final isEliteForce = combatGroup?.roster?.isEliteForce;
        if (isEliteForce != null && isEliteForce && !u.isVeteran) {
          final e = _ensureVetStatus(u, tryFix: tryFix);
          if (e.isNotValid()) {
            validationErrors.addAll(e.validations);
            continue;
          }
        }
        if (combatGroup!.roster!.rulesetNotifer.value
            .canBeAddedToGroup(u, this, combatGroup!)
            .isNotValid()) {
          validationErrors.add(
            Validation(false,
                issue:
                    '${u.name} no longer can be part of the $groupType of $combatGroup'),
          );

          if (tryFix) {
            _units.remove(u);
          }
        }
      }
    }

    return validationErrors;
  }

  @override
  String toString() {
    return 'Group: ${_role.name}, TV: ${totalTV()}, NumUnits: ${numberOfUnits()}, \n\tUnits: $_units';
  }
}
