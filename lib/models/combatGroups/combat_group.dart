import 'package:flutter/material.dart';
import 'package:gearforce/data/data.dart';
import 'package:gearforce/models/combatGroups/group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/unit/unit.dart';

class CombatGroup extends ChangeNotifier {
  late final Group primary;
  late final Group secondary;
  final String name;
  bool _isVeteran = false;
  final UnitRoster? roster;

  bool get isVeteran => _isVeteran;
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
      primary.allUnits().forEach((unit) {
        unit.removeUnitMod(veteranId);
      });
    }
    notifyListeners();
  }

  CombatGroup(this.name, {Group? primary, Group? secondary, this.roster}) {
    this.primary = primary == null ? Group() : primary;
    this.secondary = secondary == null ? Group() : secondary;

    this.primary.addListener(() {
      notifyListeners();
    });
    this.secondary.addListener(() {
      notifyListeners();
    });
  }

  Map<String, dynamic> toJson() => {
        'primary': primary.toJson(),
        'secondary': secondary.toJson(),
        'name': '$name',
      };

  factory CombatGroup.fromJson(
    dynamic json,
    Data data,
    FactionType? faction,
    String? subfaction,
  ) =>
      CombatGroup(
        json['name'] as String,
        primary: Group.fromJson(json['primary'], data, faction, subfaction),
        secondary: Group.fromJson(json['secondary'], data, faction, subfaction),
      );

  int totalTV() {
    return primary.totalTV() + secondary.totalTV();
  }

  bool hasDuelist() {
    return this.primary.hasDuelist() || this.secondary.hasDuelist();
  }

  int modCount(String id) {
    return primary.modCount(id) + secondary.modCount(id);
  }

  List<Unit> unitsWithMod(String id) {
    return primary.unitsWithMod(id).toList()
      ..addAll(secondary.unitsWithMod(id).toList());
  }

  void clear() {
    this.primary.reset();
    this.secondary.reset();
    this._isVeteran = false;
  }

  @override
  String toString() {
    return 'CombatGroup: {Name: $name, PrimaryCG: $primary, SecondaryCG: $secondary}';
  }
}
