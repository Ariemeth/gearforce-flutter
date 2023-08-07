import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/black_talons/black_talons.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const _baseFactionModId = 'mod::faction::blackTalon';
const theChosenId = '$_baseFactionModId::10';

class BlackTalonMods extends FactionModification {
  BlackTalonMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    The force leader may purchase 1 extra CP for 2 TV.
  */
  factory BlackTalonMods.theChosen() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleTheChosen.id)) {
        return false;
      }

      final forceLeader = ur?.selectedForceLeader;
      if (forceLeader == u) {
        return true;
      }

      return false;
    };

    final fm = BlackTalonMods(
      name: 'The Chosen',
      requirementCheck: reqCheck,
      id: theChosenId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    fm.addMod(UnitAttribute.cp, createSimpleIntMod(1), description: '+1 CP');

    return fm;
  }
}
