import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/validation/validations.dart';

const RoleType _defaultRoleType = RoleType.GP;

enum GroupType {
  Primary('Primary'),
  Secondary('Secondary');

  const GroupType(this.name);
  final String name;
}

class Group extends ChangeNotifier {
  RoleType _role = _defaultRoleType;
  final List<Unit> _units = [];
  final GroupType groupType;
  CombatGroup? combatGroup;

  Group(this.groupType, {RoleType role = _defaultRoleType}) {
    this._role = role;
  }

  bool unitHasTag(String tag) => _units.any((u) => u.hasTag(tag));

  Map<String, dynamic> toJson() => {
        'role': _role.toString().split('.').last,
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

    var decodedUnits = json['units'] as List;
    try {
      decodedUnits
          .map((e) => Unit.fromJson(e, faction, ruleset, cg, roster))
          .toList()
        ..forEach((u) {
          g._addUnit(u);
        });
    } on Exception catch (e) {
      print(
          'Exception caught while decoding units in $groupType of ${cg.name}: $e');
    }

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

  Validation? _addUnit(Unit unit) {
    if (_units.contains(unit)) {
      return Validation(
          issue: 'Unit ${unit.name} is already in $groupType in $combatGroup');
    }

    _units.add(unit
      ..group = this
      ..addListener(() {
        notifyListeners();
      }));
    return null;
  }

  void addUnit(Unit unit) {
    final errors = _addUnit(unit);
    if (errors != null) {
      print(errors.issue);
    } else {
      if (unit.group == null) {
        unit.group = this;
      }
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

  int tagCount(String tag) {
    return unitsWithTag(tag).length;
  }

  List<Unit> unitsWithTag(String tag) {
    return _units.where((unit) => unit.hasTag(tag)).toList();
  }

  bool isEmpty() => _units.isEmpty;

  void reset() {
    _role = _defaultRoleType;
    _units.clear();
    notifyListeners();
  }

  int totalTV() {
    var total = 0;
    _units.forEach((u) {
      total += u.tv;
    });

    return total;
  }

  int totalActions() {
    var total = 0;
    _units.where((u) => u.core.type != ModelType.Drone).forEach((u) {
      total += u.actions ?? 0;
    });
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

  List<Validation> validate({bool tryFix = false}) {
    final List<Validation> validationErrors = [];

    _units.toList().forEach((u) {
      final ve = u.validate(tryFix: tryFix);
      if (ve.isNotEmpty) {
        validationErrors.addAll(ve);
      }
    });

    if (combatGroup != null && combatGroup!.roster != null) {
      final tempList = _units.toList(growable: false);
      tempList.reversed.forEach((u) {
        if (!combatGroup!.roster!.rulesetNotifer.value
            .canBeAddedToGroup(u, this, combatGroup!)) {
          validationErrors.add(Validation(
              issue:
                  '${u.name} no longer can be part of the $groupType of $combatGroup'));
          _units.remove(u);
        }
      });
    }

    return validationErrors;
  }

  @override
  String toString() {
    return 'Group: ${_role.name}, TV: ${totalTV()}, NumUnits: ${numberOfUnits()}, \n\tUnits: $_units';
  }
}
