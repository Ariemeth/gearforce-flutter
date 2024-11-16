import 'package:gearforce/v3/models/mods/veteranUpgrades/veteran_modification.dart';
import 'package:gearforce/v3/models/rules/alpha_beta/base.dart';
import 'package:gearforce/v3/models/rules/rule.dart';
import 'package:gearforce/v3/models/rules/rule_types.dart';

final Rule ruleVeteranCombatGroups = Rule(
  name: 'Veteran Combat Groups',
  id: ruleVeteranCombatGroupsId,
  ruleType: RuleType.alphaBeta,
  modCostOverride: (modID, u) {
    if (modID != veteranId) {
      return null;
    }

    final cg = u.combatGroup;
    if (cg == null) {
      return null;
    }

    final numberOfVetMods =
        cg.units.where((unit) => unit != u && unit.hasMod(veteranId)).length;
    if (numberOfVetMods <= 2) {
      return null;
    }

    return 0;
  },
  combatGroupTVModifier: (cg) {
    if (!cg.isVeteran) {
      return 0;
    }

    final numberOfVetMods =
        cg.units.where((unit) => unit.hasMod(veteranId)).length;
    if (numberOfVetMods > 3) {
      return 6;
    }

    return 0;
  },
  description: 'Units in a Veteran Combat Group may all be made a Veteran for' +
      ' a combined 6 TV.',
);
