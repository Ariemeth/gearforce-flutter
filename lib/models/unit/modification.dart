import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Modification {
  Modification({
    required this.name,
    this.requirementCheck = _defaultRequirementsFunction,
  });

  final String name;

  // function to ensure the modification can be applied to the unit
  final bool Function(UnitCore) requirementCheck;

  final Map<UnitAttribute, dynamic Function(dynamic)> _changes = new Map();

  static bool _defaultRequirementsFunction(dynamic u) => true;

  void addMod(UnitAttribute att, dynamic Function(dynamic) mod) {
    this._changes[att] = mod;
  }

  dynamic applyMods(UnitAttribute att, dynamic startingValue) {
    var mod = this._changes[att];
    if (mod != null) {
      return mod(startingValue);
    }

    return startingValue;
  }
}
