import 'package:flutter/material.dart';
import 'package:gearforce/models/unit/role.dart';
import 'package:gearforce/models/unit/unit.dart';

class Group {
  final ValueNotifier<RoleType?> role = ValueNotifier(null);
  List<Unit> units = [];

  Group({RoleType? role}) {
    this.role.value = role;
  }

  void reset() {
    this.role.value = null;
    this.units = [];
  }

  int totalTV() {
    var total = 0;
    this.units.forEach((element) {
      total += element.tv;
    });

    return total;
  }

  @override
  String toString() {
    return 'Group: {Role: ${role.value}, Units: $units}';
  }
}
