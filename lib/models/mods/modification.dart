import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Modification {
  Modification({
    required this.name,
    this.requirementCheck = _defaultRequirementsFunction,
  });

  final String name;
  final List<String> _description = [];

  List<String> get description => this._description.toList();

  // function to ensure the modification can be applied to the unit
  final bool Function(UnitCore) requirementCheck;

  final Map<UnitAttribute, dynamic Function(dynamic)> _mods = Map();

  static bool _defaultRequirementsFunction(dynamic u) => true;

  void addMod(UnitAttribute att, dynamic Function(dynamic) mod,
      {String? description}) {
    this._mods[att] = mod;
    if (description != null) {
      this._description.add(description);
    }
  }

  dynamic applyMods(UnitAttribute att, dynamic startingValue) {
    var mod = this._mods[att];
    if (mod != null) {
      return mod(startingValue);
    }

    return startingValue;
  }
}
