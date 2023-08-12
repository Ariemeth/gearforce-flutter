import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rule_set.dart';
import 'package:gearforce/models/rules/utopia/caf.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';

const _baseFactionModId = 'mod::faction::utopia';
const quietDeathId = '$_baseFactionModId::10';
const silentAssaultId = '$_baseFactionModId::20';
const wrathOfTheDemigodsId = '$_baseFactionModId::30';
const notSoSilentAssaultId = '$_baseFactionModId::40';
const whoDaresId = '$_baseFactionModId::50';

class UtopiaMods extends FactionModification {
  UtopiaMods({
    required super.name,
    required super.id,
    required super.requirementCheck,
    super.options,
    super.onAdd,
    super.onRemove,
  }) : super();

  /*
    Recce Armigers may purchase the React+ trait for 1 TV each.
  */
  factory UtopiaMods.quietDeath() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleQuietDeath.id)) {
        return false;
      }

      if (u.core.frame == 'Recce Armiger') {
        return true;
      }
      return false;
    };

    final fm = UtopiaMods(
      name: 'Quiet Death',
      requirementCheck: reqCheck,
      id: quietDeathId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.ReactPlus()),
      description: 'Recce Armigers may purchase the React+ trait.',
    );

    return fm;
  }

  /*
    Recce N-KIDUs may increase their EW skill by one for 1 TV each.
  */
  factory UtopiaMods.silentAssault() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleSilentAssault.id)) {
        return false;
      }

      if (u.core.frame == 'Recce N-KIDU') {
        return true;
      }
      return false;
    };

    final fm = UtopiaMods(
      name: 'Silent Assault',
      requirementCheck: reqCheck,
      id: silentAssaultId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.ew,
      createSimpleIntMod(-1),
      description: 'Recce N-KIDUs may increase their EW skill by one.',
    );

    return fm;
  }

  /*
    Each Support Armiger may upgrade their MRP with both the Precise trait and
    the Guided trait for 1 TV total.
  */
  factory UtopiaMods.wrathOfTheDemigods() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleWrathOfTheDemigods.id)) {
        return false;
      }

      if (u.core.frame == 'Support Armiger') {
        return true;
      }
      return false;
    };

    final fm = UtopiaMods(
      name: 'Wrath of the Demigods',
      requirementCheck: reqCheck,
      id: wrathOfTheDemigodsId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    final precise = Trait.Precise();
    final guided = Trait.Guided();

    fm.addMod<List<Weapon>>(
      UnitAttribute.weapons,
      (value) {
        var newList = new List<Weapon>.from(value);

        if (!newList.any((w) => w.code == 'RP')) {
          return newList;
        }
        final rp = newList.firstWhere((w) => w.code == 'RP');

        final modifiedWeapon =
            Weapon.fromWeapon(rp, addTraits: [precise, guided]);

        newList.remove(rp);
        if (!newList.contains(modifiedWeapon)) {
          newList.add(modifiedWeapon);
        }

        return newList;
      },
      description: 'Each Support Armiger may upgrade their MRP with both the' +
          ' Precise trait and the Guided trait.',
    );

    return fm;
  }

  /*
    Support N-KIDUs may increase their GU skill by one for
    1 TV each.
  */
  factory UtopiaMods.notSoSilentAssault() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleNotSoSilentAssault.id)) {
        return false;
      }

      if (u.core.frame == 'Support N-KIDU') {
        return true;
      }
      return false;
    };

    final fm = UtopiaMods(
      name: 'Not So Silent Assault',
      requirementCheck: reqCheck,
      id: notSoSilentAssaultId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(1),
      description: 'TV: +1',
    );

    fm.addMod<int>(
      UnitAttribute.gunnery,
      createSimpleIntMod(-1),
      description: 'Support N-KIDUs may increase their GU skill by one.',
    );

    return fm;
  }

  /*
    Commando Armigers may add +1 action for 2 TV each.
  */
  factory UtopiaMods.whoDares() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleWhoDares.id)) {
        return false;
      }

      if (u.core.frame == 'Commando Armiger') {
        return true;
      }
      return false;
    };

    final fm = UtopiaMods(
      name: 'Who Dares',
      requirementCheck: reqCheck,
      id: whoDaresId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(2),
      description: 'TV: +2',
    );

    fm.addMod<int>(
      UnitAttribute.actions,
      createSimpleIntMod(1),
      description: 'Commando Armigers may add +1 action.',
    );

    return fm;
  }
}
