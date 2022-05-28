import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/command.dart';
import 'package:gearforce/models/unit/unit.dart';

class CombatGroup extends ChangeNotifier {
  Group _primary = Group();
  Group _secondary = Group();
  final String name;
  bool _isVeteran = false;
  final UnitRoster? roster;

  Group get primary => _primary;
  set primary(Group group) {
    if (_primary.hasListeners) {
      _primary.removeListener(() {
        notifyListeners();
      });
    }
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
      if ((roster != null && roster!.getCGs().any((cg) => cg._isVeteran))) {
        return;
      }
    }
    _isVeteran = value;
    if (!value) {
      _primary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
      _secondary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
    }
    notifyListeners();
  }

  bool get isEliteForce => roster != null && roster!.isEliteForce;
  set isEliteForce(bool newValue) {
    if (!newValue && !isVeteran) {
      _primary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
      _secondary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
    }
  }

  CombatGroup(this.name, {Group? primary, Group? secondary, this.roster}) {
    this.primary = primary == null ? Group() : primary;
    this.secondary = secondary == null ? Group() : secondary;
  }

  Map<String, dynamic> toJson() => {
        'primary': _primary.toJson(),
        'secondary': _secondary.toJson(),
        'name': '$name',
        'isVet': _isVeteran,
      };

  factory CombatGroup.fromJson(
    dynamic json,
    Data data,
    FactionType? faction,
    String? subfaction,
    UnitRoster roster,
  ) {
    final cg = CombatGroup(
      json['name'] as String,
      roster: roster,
    ).._isVeteran = json['isVet'] != null ? json['isVet'] as bool : false;

    final p = Group.fromJson(
      json['primary'],
      data,
      faction,
      subfaction,
      cg,
      roster,
    );
    final s = Group.fromJson(
      json['secondary'],
      data,
      faction,
      subfaction,
      cg,
      roster,
    );
    cg.primary = p;
    cg.secondary = s;

    return cg;
  }

  int totalTV() {
    return _primary.totalTV() + _secondary.totalTV();
  }

  bool hasDuelist() {
    return this._primary.hasDuelist() || this._secondary.hasDuelist();
  }

  int modCount(String id) {
    return _primary.modCount(id) + _secondary.modCount(id);
  }

  Unit? getUnitWithCommand(CommandLevel cl) {
    return _primary.getUnitWithCommand(cl) ?? _secondary.getUnitWithCommand(cl);
  }

  List<Unit> unitsWithMod(String id) {
    return _primary.unitsWithMod(id).toList()
      ..addAll(_secondary.unitsWithMod(id).toList());
  }

  // Retrieve the total number of units in the combat group
  int numberOfUnits() {
    return _primary.numberOfUnits() + _secondary.numberOfUnits();
  }

  void clear() {
    this._primary.reset();
    this._secondary.reset();
    this._isVeteran = false;
  }

  @override
  String toString() {
    return 'CombatGroup: {Name: $name, PrimaryCG: $_primary, SecondaryCG: $_secondary}';
  }
}
