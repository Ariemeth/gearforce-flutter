import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

class Group extends ChangeNotifier {
  final ValueNotifier<RoleType?> role = ValueNotifier(null);
  final List<Unit> _units = [];

  Group({RoleType? role}) {
    this.role.value = role;
  }

  void addUnit(Unit unit) {
    _units.add(unit);
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
      total += element.tv;
    });

    return total;
  }

  int totalActions() {
    var total = 0;
    this._units.forEach((element) {
      total += element.actions ?? 0;
    });
    return total;
  }

  @override
  String toString() {
    return 'Group: {Role: ${role.value}, Units: $_units}';
  }
}
