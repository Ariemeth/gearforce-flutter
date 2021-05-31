import 'package:gearforce/models/unit/modification.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Unit {
  Unit({
    required this.core,
  });

  final UnitCore core;

  String name() {
    return this.core.name;
  }

  int? ew() {
    return this.core.ew;
  }

  final List<Modification> mods = [];
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
