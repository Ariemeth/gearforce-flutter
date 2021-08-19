import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/unit/unit.dart';

class Modification extends BaseModification {
  Modification({
    required String name,
    this.requirementCheck = _defaultRequirementsFunction,
    ModificationOption? options,
    String? id,
  }) : super(name: name, options: options, id: id);

  // function to ensure the modification can be applied to the unit
  final bool Function(Unit) requirementCheck;

  static bool _defaultRequirementsFunction(Unit u) => true;
}
