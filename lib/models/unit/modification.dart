import 'package:gearforce/models/unit/unit_core.dart';

class Modification {
  Modification({
    required this.name,
    this.requirementCheck = _defaultRequirementsFunction,
  });

  final String name;

  // function to ensure the modification can be applied to the unit
  final bool Function(UnitCore) requirementCheck;

  // list of affects on each attribute
  // affects include, remove, add, change
  static bool _defaultRequirementsFunction(UnitCore u) => true;
}
