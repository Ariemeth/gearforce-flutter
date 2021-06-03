import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Group extends ChangeNotifier {
  final ValueNotifier<RoleType?> role = ValueNotifier(null);
  final List<Unit> _units = [];

  Group({RoleType? role}) {
    this.role.value = role;
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
    this.role.value = null;
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
    return 'Group: {Role: ${role.value}, Units: $_units}';
  }
}
