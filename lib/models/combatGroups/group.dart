import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

const RoleType _defaultRoleType = RoleType.GP;

class Group extends ChangeNotifier {
  RoleType _role = _defaultRoleType;
  final List<Unit> _units = [];

  Group({RoleType role = _defaultRoleType}) {
    this._role = role;
  }

  RoleType role() => _role;

  void changeRole(RoleType role) {
    if (role == this._role) {
      return;
    }

    this._role = role;

    _units.removeWhere((unit) {
      return !unit.role()!.includesRole([this._role]);
    });

    notifyListeners();
  }

  void addUnit(UnitCore unit) {
    _units.add(Unit(core: unit)
      ..addListener(() {
        notifyListeners();
      }));
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

  void reset() {
    this._role = _defaultRoleType;
    this._units.clear();
    notifyListeners();
  }

  int totalTV() {
    var total = 0;
    this._units.forEach((element) {
      total += element.tv();
    });

    return total;
  }

  int totalActions() {
    var total = 0;
    this._units.forEach((element) {
      total += element.attribute(UnitAttribute.actions) as int? ?? 0;
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

  @override
  String toString() {
    return 'Group: {Role: $_role, Units: $_units}';
  }
}
