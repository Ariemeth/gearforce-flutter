import 'package:gearforce/models/combatGroups/combat_group.dart';
import 'package:gearforce/models/factions/faction_type.dart';
import 'package:gearforce/models/mods/base_modification.dart';
import 'package:gearforce/models/mods/factionUpgrades/faction_mod.dart';
import 'package:gearforce/models/mods/mods.dart';
import 'package:gearforce/models/roster/roster.dart';
import 'package:gearforce/models/rules/rulesets/rule_set.dart';
import 'package:gearforce/models/rules/rulesets/utopia/caf.dart';
import 'package:gearforce/models/rules/rulesets/utopia/ouf.dart';
import 'package:gearforce/models/traits/trait.dart';
import 'package:gearforce/models/unit/model_type.dart';
import 'package:gearforce/models/unit/unit.dart';
import 'package:gearforce/models/unit/unit_attribute.dart';
import 'package:gearforce/models/weapons/weapon.dart';

const _baseFactionModId = 'mod::faction::utopia';
const quietDeathId = '$_baseFactionModId::10';
const silentAssaultId = '$_baseFactionModId::20';
const wrathOfTheDemigodsId = '$_baseFactionModId::30';
const notSoSilentAssaultId = '$_baseFactionModId::40';
const whoDaresId = '$_baseFactionModId::50';
const greenwayCausticsId = '$_baseFactionModId::60';
const naiExperimentsId = '$_baseFactionModId::70';
const frankNKiduId = '$_baseFactionModId::80';

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

      if (!cg!.isOptionEnabled(ruleRecceTroupe.id)) {
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
      if (!cg!.isOptionEnabled(ruleRecceTroupe.id)) {
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

      if (!cg!.isOptionEnabled(ruleSupportTroupe.id)) {
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

      if (!cg!.isOptionEnabled(ruleSupportTroupe.id)) {
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

      if (!cg!.isOptionEnabled(ruleCommandoTroupe.id)) {
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

  /*
    Models in one combat group may add the Corrosion trait
    to, and remove the AP trait from, their rocket packs for 0 TV.
  */
  factory UtopiaMods.greenwayCaustics() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleGreenwayCaustics.id)) {
        return false;
      }

      if (!cg!.isOptionEnabled(ruleGreenwayCaustics.id)) {
        return false;
      }

      if (u.weapons.any((w) => w.code == 'RP')) {
        return true;
      }

      return false;
    };

    final fm = UtopiaMods(
      name: 'Greenway Caustics',
      requirementCheck: reqCheck,
      id: greenwayCausticsId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(0),
      description: 'TV: 0',
    );

    final corrosion = Trait.Corrosion();
    final ap = Trait.AP(1);

    fm.addMod<List<Weapon>>(
      UnitAttribute.weapons,
      (value) {
        var newList = new List<Weapon>.from(value);

        if (!newList.any((w) => w.code == 'RP')) {
          return newList;
        }
        final rp = newList.firstWhere((w) => w.code == 'RP');

        final modifiedWeapon = Weapon.fromWeapon(rp, addTraits: [corrosion]);
        modifiedWeapon.baseTraits.removeWhere((t) => ap.isSameType(t));

        newList.remove(rp);
        if (!newList.contains(modifiedWeapon)) {
          newList.add(modifiedWeapon);
        }

        return newList;
      },
      description: 'Models in one combat group may add the Corrosion trait' +
          ' to, and remove the AP trait.',
    );

    return fm;
  }

  /*
    This force may include CEF frames regardless of any allies
    chosen. CEF frames may add the Conscript trait for -1 TV. The CEF’s Minerva
    and Advanced Interface Network upgrades cannot be selected. Commanders,
    veterans and duelists may not receive the Conscript trait.
  */
  factory UtopiaMods.naiExperiments() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleNAIExperiements.id)) {
        return false;
      }

      if (u.type == ModelType.Gear && u.faction == FactionType.CEF) {
        return true;
      }

      return false;
    };

    final fm = UtopiaMods(
      name: 'NAI Experiments',
      requirementCheck: reqCheck,
      id: naiExperimentsId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(-1),
      description: 'TV: -1',
    );

    fm.addMod<List<Trait>>(
      UnitAttribute.traits,
      createAddTraitToList(Trait.Conscript()),
      description: 'CEF frames may add the Conscript trait.',
    );

    return fm;
  }

  /*
    One N-KIDU per combat group may purchase one veteran or
    duelist upgrade without being a veteran or a duelist.
  */
  factory UtopiaMods.frankNKidu() {
    final RequirementCheck reqCheck =
        (RuleSet? rs, UnitRoster? ur, CombatGroup? cg, Unit u) {
      assert(cg != null);
      assert(rs != null);

      if (rs == null || !rs.isRuleEnabled(ruleFrankNKidu.id)) {
        return false;
      }

      final modCount =
          cg?.unitsWithMod(ruleFrankNKidu.id).where((unit) => unit != u).length;

      if (modCount == 0 && u.core.frame.contains('N-KIDU')) {
        return true;
      }

      return false;
    };

    final fm = UtopiaMods(
      name: 'Frank-N-KIDU',
      requirementCheck: reqCheck,
      id: frankNKiduId,
    );

    fm.addMod<int>(
      UnitAttribute.tv,
      createSimpleIntMod(0),
      description: 'One N-KIDU per combat group may purchase one veteran or' +
          ' duelist upgrade without being a veteran or a duelist.',
    );

    return fm;
  }
}
