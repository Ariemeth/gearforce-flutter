import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/modification_option.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/north/north.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';

const _northernIDBase = 'mod::faction::northern';

const taskBuiltID = '$_northernIDBase::10';
const hammersOfTheNorth = '$_northernIDBase::20';

class NorthernFactionMods extends FactionModification {
  NorthernFactionMods({
    required String name,
    required RequirementCheck requirementCheck,
    ModificationOption? options,
    required String id,
  }) : super(
          name: name,
          requirementCheck: requirementCheck,
          options: options,
          id: id,
        );
  factory NorthernFactionMods.taskBuilt() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleTaskBuilt.id)) {
        return false;
      }

      return true;
    };
    return NorthernFactionMods(
      name: 'Task Built',
      requirementCheck: reqCheck,
      id: taskBuiltID,
    );
  }
}
