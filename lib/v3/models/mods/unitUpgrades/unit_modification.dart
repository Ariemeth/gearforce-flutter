import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';
import 'package:gearforce/v3/models/unit/unit.dart';

class UnitModification extends BaseModification {
  UnitModification({
    required super.name,
    super.requirementCheck = _defaultRequirementsFunction,
    super.options,
    String? id,
    super.ruleType = RuleType.standard,
  }) : super(
          id: id ?? name,
          modType: ModificationType.unit,
        );

  // function to ensure the modification can be applied to the unit

  static bool _defaultRequirementsFunction(
    RuleSet? rs,
    UnitRoster? ur,
    CombatGroup? cg,
    Unit u,
  ) =>
      true;
}
