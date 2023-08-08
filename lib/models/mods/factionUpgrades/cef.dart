import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/cef/cef.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';

const _baseFactionModId = 'mod::faction::cef';
const minveraId = '$_baseFactionModId::10';
const advancedInterfaceNetworkId = '$_baseFactionModId::20';
const valkyriesId = '$_baseFactionModId::30';
const ewDuelistsId = '$_baseFactionModId::40';

class CEFMods extends FactionModification {
  CEFMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    CEF frames may choose to have a Minerva class GREL as a pilot for 1 TV each.
    This will improve the PI skill of that frame by one.
  */
  factory CEFMods.minerva() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleMinvera.id)) {
        return false;
      }

      if (u.faction == FactionType.CEF && u.type == ModelType.Gear) {
        return true;
      }

      return false;
    };

    final fm = CEFMods(
      name: 'Minvera',
      requirementCheck: reqCheck,
      id: minveraId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.piloting,
      createSimpleIntMod(-1),
      description:
          'Improve PI skill by 1 by adding a Minvera class' + ' GREL pilot',
    );

    return fm;
  }

  /*
    Each veteran CEF frame may improve their GU skill by one for 1 TV times the
    number of Actions that the model has.
  */
  factory CEFMods.advancedInterfaceNetwork(Unit unit) {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleAdvancedInterfaceNetwork.id)) {
        return false;
      }

      if (u.faction == FactionType.CEF &&
          u.type == ModelType.Gear &&
          u.isVeteran) {
        return true;
      }

      return false;
    };

    final fm = CEFMods(
      name: 'Advanced Interface Network',
      requirementCheck: reqCheck,
      id: advancedInterfaceNetworkId,
    );

    final modCost = unit.actions ?? 0;

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(modCost),
      description: 'TV: +$modCost',
    );

    fm.addMod<int>(
      UnitAttribute.gunnery,
      createSimpleIntMod(-1),
      description: 'Improve GU skill by 1',
    );

    return fm;
  }

  /*
    Veteran frames in this force with 1 action may upgrade to 2 actions
    for +2 TV each.
  */
  factory CEFMods.valkyries() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      // if (rs == null || !rs.isRuleEnabled(ruleAdvancedInterfaceNetwork.id)) {
      //   return false;
      // }

      return false;
    };

    final fm = CEFMods(
      name: 'Valkyries',
      requirementCheck: reqCheck,
      id: valkyriesId,
    );

    return fm;
  }

  /*
    Each duelist frame may purchase the ECM trait and the Sensors:36
    trait for 1 TV total.
  */
  factory CEFMods.ewDuelists() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      // if (rs == null || !rs.isRuleEnabled(ruleAdvancedInterfaceNetwork.id)) {
      //   return false;
      // }

      return false;
    };

    final fm = CEFMods(
      name: 'EW Duelists',
      requirementCheck: reqCheck,
      id: ewDuelistsId,
    );

    return fm;
  }
}
