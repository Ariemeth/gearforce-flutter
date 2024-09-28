import 'package:gearforce/v3/models/combatGroups/combat_group.dart';
import 'package:gearforce/v3/models/mods/base_modification.dart';
import 'package:gearforce/v3/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/v3/models/mods/mods.dart';
import 'package:gearforce/v3/models/roster/roster.dart';
import 'package:gearforce/v3/models/rules/rulesets/black_talons/black_talons.dart';
import 'package:gearforce/v3/models/rules/rulesets/black_talons/btit.dart';
import 'package:gearforce/v3/models/rules/rulesets/black_talons/btrt.dart';
import 'package:gearforce/v3/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/v3/models/traits/trait.dart';
import 'package:gearforce/v3/models/unit/unit.dart';
import 'package:gearforce/v3/models/unit/unit_attribute.dart';

const _baseFactionModId = 'mod::faction::blackTalon';
const theChosenId = '$_baseFactionModId::10';
const theUnseenId = '$_baseFactionModId::20';
const radioBlackoutId = '$_baseFactionModId::30';
const theTalonsId = '$_baseFactionModId::40';

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

  /*
    Dark Cheetahs and Dark Skirmishers may add +1 action for 2 TV each.
  */
  factory BlackTalonMods.theUnseen() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleTheUnseen.id)) {
        return false;
      }

      final frame = u.core.frame;
      if (frame == 'Dark Cheetah' || frame == 'Dark Skirmisher') {
        return true;
      }

      return false;
    };

    final fm = BlackTalonMods(
      name: 'The Unseen',
      requirementCheck: reqCheck,
      id: theUnseenId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    fm.addMod<int>(
      UnitAttribute.actions,
      createSimpleIntMod(1),
      description: '+1 actions',
    );

    return fm;
  }

  /*
    One model per combat group with the ECM, or ECM+ trait may
    improve its EW skill by one for 1 TV each.
  */
  factory BlackTalonMods.RadioBlackout() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleRadioBlackout.id)) {
        return false;
      }

      if (!u.traits.any(
          (t) => Trait.ECM().isSameType(t) || Trait.ECMPlus().isSameType(t))) {
        return false;
      }

      final unitsWithMod =
          cg?.unitsWithMod(radioBlackoutId).where((unit) => unit != u);

      if (unitsWithMod == null || (unitsWithMod.isEmpty)) {
        return true;
      }

      return false;
    };

    final fm = BlackTalonMods(
      name: 'Radio Blackout',
      requirementCheck: reqCheck,
      id: radioBlackoutId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.ew,
      createSimpleIntMod(-1),
      description: 'Improve EW by 1',
    );

    return fm;
  }

  /*
    Dark Jaguars and Dark Mambas may add +1 action for 2 TV each.
  */
  factory BlackTalonMods.theTalons() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleTheTalons.id)) {
        return false;
      }

      final frame = u.core.frame;
      if (frame == 'Dark Jaguar' || frame == 'Dark Mamba') {
        return true;
      }

      return false;
    };

    final fm = BlackTalonMods(
      name: 'The Talons',
      requirementCheck: reqCheck,
      id: theTalonsId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    fm.addMod<int>(
      UnitAttribute.actions,
      createSimpleIntMod(1),
      description: '+1 actions',
    );

    return fm;
  }
}
