import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_core.dart';

class Modification {
  Modification({
    required this.name,
    required this.changes,
    this.requirementCheck = _defaultRequirementsFunction,
  });

  final String name;

  // function to ensure the modification can be applied to the unit
  final bool Function(UnitCore) requirementCheck;

  final Map<UnitAttribute, List<dynamic Function(UnitCore)>> changes;

  static bool _defaultRequirementsFunction(UnitCore u) => true;
}
