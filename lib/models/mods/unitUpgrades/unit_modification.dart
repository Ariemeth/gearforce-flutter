import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';

class UnitModification extends BaseModification {
  UnitModification({
    required String name,
    RequirementCheck requirementCheck = _defaultRequirementsFunction,
    ModificationOption? options,
    String? id,
  }) : super(
            name: name,
            requirementCheck: requirementCheck,
            options: options,
            id: id ?? name);

  // function to ensure the modification can be applied to the unit

  static bool _defaultRequirementsFunction(
          RuleSet rs, CombatGroup cg, Unit u) =>
      true;
}
