import 'package:flutter/material.dart';
import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction.dart';
import 'package:gearforce/models/factions/sub_faction.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
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
    SubFaction subfaction,
    CombatGroup cg,
    UnitRoster roster,
    GroupType groupType,
  ) {
    Group g = Group(groupType, role: convertRoleType(json['role'] as String));

    var decodedUnits = json['units'] as List;
    decodedUnits
        .map((e) => Unit.fromJson(e, faction, subfaction, cg, roster))
        .toList()
      ..forEach((u) {
        g._addUnit(u);
      });

    return g;
  }

  RoleType role() => _role;

  void changeRole(RoleType role) {
    if (role == this._role) {
      return;
    }

    this._role = role;

    _units.removeWhere((unit) {
      return !unit.role!.includesRole([this._role]);
    });

    notifyListeners();
  }

  void _addUnit(Unit unit) {
    _units.add(unit
      ..addListener(() {
        notifyListeners();
      }));
  }

  void addUnit(Unit unit) {
    _addUnit(unit);
    notifyListeners();
  }

  void removeUnit(int index) {
    if (index < _units.length) {
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

  int modCount(String id) {
    return unitsWithMod(id).length;
  }

  List<Unit> unitsWithMod(String id) {
    return this._units.where((unit) => unit.hasMod(id)).toList();
  }

  int tagCount(String tag) {
    return unitsWithTag(tag).length;
  }

  List<Unit> unitsWithTag(String tag) {
    return this._units.where((unit) => unit.hasTag(tag)).toList();
  }

  void reset() {
    this._role = _defaultRoleType;
    this._units.clear();
    notifyListeners();
  }

  int totalTV() {
    var total = 0;
    this._units.forEach((u) {
      total += u.tv;
    });

    return total;
  }

  int totalActions() {
    var total = 0;
    this._units.forEach((u) {
      if (u.core.type != ModelType.Drone) {
        total += u.actions ?? 0;
      }
    });
    return total;
  }

  bool hasDuelist() {
    for (final u in _units) {
      if (u.isDuelist) {
        return true;
      }
    }
    return false;
  }

  List<Validation> validate(
      RuleSet ruleset, UnitRoster unitRoster, CombatGroup combatGroup) {
    // TODO check to ensure each units mods requirements are met and remove those
    // that do not
    print('group validation called');
    return [];
  }

  @override
  String toString() {
    return 'Group: {Role: $_role, Units: $_units}';
  }
}
