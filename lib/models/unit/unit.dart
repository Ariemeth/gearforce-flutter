import 'package:gearforce/models/unit/unit_core.dart';

class Unit {
  Unit({
    required this.core,
  });

  String name() {
    return this.core.name;
  }

  int? ew() {
    return this.core.ew;
  }

  final UnitCore core;
}

enum UnitAttribute {
  name,
  tv,
  roles,
  movement,
  armor,
  hull,
  structure,
  actions,
  gunnery,
  piloting,
  ew,
  react_weapons,
  mounted_weapons,
  traits,
  type,
  height,
}
